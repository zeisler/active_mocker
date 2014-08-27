$:.unshift File.expand_path('../../', __FILE__)
require 'active_mocker/active_record/scope'
require 'active_mocker/active_record/unknown_class_method'
require 'active_mocker/active_record/unknown_module'

module ActiveMocker
  # @api private
  module ActiveRecord
    class Base
      extend Scope
      extend UnknownClassMethod

      def self.inherited(subclass)
        return if subclass.superclass == Base
        instance_variables.each do |instance_var|
          subclass.instance_variable_set(instance_var, instance_variable_get(instance_var))
        end
      end

      def self.table_name=(table_name)
        @table_name = table_name
      end

      def self.table_name
        @table_name ||= nil
        @table_name
      end

      def self.primary_key=(primary_key)
        @primary_key = primary_key
      end

      def self.primary_key
        @primary_key ||= nil
        @primary_key
      end

      module ConstMissing

        def const_missing(name)
          Config.logger.debug "ActiveMocker :: DEBUG :: const_missing #{name} from class #{self.name}. Creating Class.\n  #{caller.first}\n"
          m = Module.new
          m.extend ConstMissing
          self.const_set name, m
        end

      end

      def self.const_missing(name)
        Config.logger.debug "ActiveMocker :: DEBUG :: const_missing #{name} from class #{self.name.demodulize }. Creating Class.\n  #{caller.first}\n"
        m = Module.new
        m.extend ConstMissing
        Object.const_set name, m
      end

      def self.include(name)
        _included << name
      end

      def self._included
        @included ||= []
      end

      def self.extend(name)
        _extended << name
      end

      def self._extended
        @extended ||= []
      end
    end
  end
end
