module ActiveMocker
  class MockCreator
    module DefinedMethods
      Method = Struct.new(:name, :arguments, :body)

      def instance_methods
        meths = class_introspector.get_class.public_instance_methods(false).sort
        if safe_methods.include?(:initialize)
          meths << :initialize
        end
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

      def safe_methods
        @safe_methods ||= class_introspector.parsed_source.comments.flat_map do |comment|
          if comment.text.include?("ActiveMocker.safe_methods")
            ActiveMocker.module_eval(comment.text.delete("#"))
          end
        end
      end

      module ActiveMocker
        def self.safe_methods(*methods)
          methods
        end
      end

      def create_method(m, type)
        if safe_methods.include?(m)
          def_method = class_introspector.parsed_source.defs.detect { |meth| meth.name == m }
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
