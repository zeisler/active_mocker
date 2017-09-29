# frozen_string_literal: true
require_relative "safe_methods"
module ActiveMocker
  class MockCreator
    module DefinedMethods
      include SafeMethods
      Method = Struct.new(:name, :arguments, :body)

      def instance_methods
        meths = class_introspector.get_class.public_instance_methods(false).sort
        meths << :initialize if safe_methods[:instance_methods].include?(:initialize)
        meths.map { |m| create_method(m, :instance_method) }
      end

      def class_methods
        class_introspector
          .get_class
          .methods(false)
          .sort
          .map { |m| create_method(m, :method) }
      end

      private

      def create_method(m, type)
        plural_type = (type.to_s + "s").to_sym
        if safe_methods[plural_type].include?(m)
          raise "ActiveMocker.safe_methods(class_methods: []) is currently unsupported." if type == :method
          def_method = class_introspector.parsed_source.defs.detect { |meth| meth.name == m }
          Method.new(
            m,
            def_method.arguments,
            def_method.body
          )
        else
          type_symbol = type == :method ? "::" : "#"
          Method.new(
            m,
            ReverseParameters.new(
              class_introspector.get_class.send(type, m).parameters
            ).parameters,
            "__am_raise_not_mocked_error(method: __method__, caller: Kernel.caller, type: '#{type_symbol}')"
          )
        end
      end
    end
  end
end
