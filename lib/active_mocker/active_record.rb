$:.unshift File.expand_path('../../', __FILE__)
require 'active_mocker/active_record/scope'
require 'active_mocker/active_record/relationships'
require 'active_mocker/active_record/unknown_class_method'
require 'active_mocker/active_record/unknown_module'

module ActiveMocker
  # @api private
  module ActiveRecord
    class Base
      extend Scope
      extend Relationships
      extend UnknownClassMethod

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

      class ConstMissing

        def self.const_missing(name)
          Logger.debug "ActiveMocker :: Debug :: const_missing #{name} from class #{self.name}.\n\t\t\t\t\t\t\t\t#{caller}\n"
          self.const_set name, Class.new(ConstMissing)
        end

      end

      def self.const_missing(name)
        Object.const_set name, Class.new(ConstMissing)
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
