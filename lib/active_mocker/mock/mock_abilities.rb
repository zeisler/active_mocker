module ActiveMocker
  module Mock
  module MockAbilities

    module InstanceAndClassMethods

      def mock_instance_method(method, exe_bind=false, &block)
        mockable_instance_methods[method.to_sym] = MockMethod.new(block, exe_bind)
      end

      alias_method :stub_instance_method, :mock_instance_method

      def clear_mocked_methods
        mockable_instance_methods.clear
        mockable_class_methods.clear
      end

      private

      def mockable_instance_methods
        @mockable_instance_methods ||= {}
      end

      def class_name
        return name if self.class == Class
        self.class
      end

      def is_implemented(val, method, type)
        raise Unimplemented, "#{type}#{method} is not Implemented for Class: #{class_name}. To continue stub the method." if val.nil?
      end

      def execute_block(method)
        return instance_exec(method.arguments, &method.block) if method.exe_bind
        method.block.call(*method.arguments)
      end

    end

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods

      include InstanceAndClassMethods

      def mockable_class_methods
        @mockable_class_methods ||= {}
      end

      def mock_class_method(method, exe_bind=false, &block)
        mockable_class_methods[method.to_sym] = MockMethod.new(block, exe_bind)
      end

      alias_method :stub_class_method, :mock_class_method

      def call_mock_method(method, *arguments)
        mock_method = mockable_class_methods[method.to_sym]
        is_implemented(mock_method, method, '::')
        mock_method.arguments = arguments
        execute_block(mock_method)
      end

      private :call_mock_method

    end

    include InstanceAndClassMethods

    def call_mock_method(method, *arguments)
      mock_method = mockable_instance_methods[method.to_sym]
      mock_method = self.class.send(:mockable_instance_methods)[method.to_sym] if mock_method.nil?
      is_implemented(mock_method, method, '#')
      mock_method.arguments = arguments
      execute_block mock_method
    end

    private :call_mock_method

    def clear_mocked_methods
      mockable_instance_methods.clear
    end

    class MockMethod

      attr_accessor :block, :arguments, :exe_bind

      def initialize(block, exe_bind)
        @block     = block
        @exe_bind  = exe_bind
      end

    end

  end
  end
end
