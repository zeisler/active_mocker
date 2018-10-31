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
        if safe_method?(type, m)
          safe_method_create(m, plural_type, type)
        else
          un_safe_create(m, type)
        end
      end

      def un_safe_create(m, type)
        type_symbol = type == :method ? "::" : "#"
        Method.new(
          m,
          ReverseParameters.new(
            class_introspector.get_class.send(type, m).parameters,
          ).parameters,
          "__am_raise_not_mocked_error(method: __method__, caller: Kernel.caller, type: '#{type_symbol}')",
        )
      end

      def safe_method_create(m, plural_type, type)
        def_type   = type == :method ? :class_defs : :defs
        def_method = class_introspector.parsed_source.public_send(def_type).detect { |meth| meth.name == m }
        raise "ActiveMocker.safe_methods is unable to find #{plural_type}: #{m}" unless def_method
        Method.new(
          m,
          def_method.arguments,
          def_method.body,
        )
      end
    end
  end
end
