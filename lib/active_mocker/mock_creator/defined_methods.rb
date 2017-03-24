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
          def_method = class_introspector.parsed_source.inspect_methods(plural_type).detect { |meth| meth.name == m }
          Method.new(
            m,
            def_method.arguments,
            def_method.body
          )
        else
          Method.new(
            m,
            ReverseParameters.new(
              class_introspector.get_class.send(type, m).parameters,
              blocks_as_values: true
            ).parameters,
            "call_mock_method(method: __method__, caller: Kernel.caller, arguments: [])"
          )
        end
      end
    end
  end
end
