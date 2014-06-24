module ActiveMocker
module Mock
  module MockAbilities

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods

      def mockable_instance_methods
        raise Unimplemented
      end

      def mockable_class_methods
        raise Unimplemented
      end

      def mock_instance_method(method, &block)
        mockable_instance_methods[method.to_s] = block
      end

      alias_method :stub_instance_method, :mock_instance_method

      def mock_class_method(method, &block)
        mockable_class_methods[method.to_s] = block
      end

      alias_method :stub_class_method, :mock_class_method

      def is_implemented(val, method, type='::')
        raise Unimplemented, "#{type}#{method} is not Implemented for Class: #{name}" if val == nil
      end

      def get_mock_class_method(method)
        method_block = mockable_class_methods[method]
        is_implemented(method_block, method)
        method_block
      end

      private :get_mock_class_method

      def clear_mocked_methods
        mockable_instance_methods.clear
        mockable_class_methods.clear
      end

    end

    def mock_instance_method(method, &block)
      @mockable_instance_methods[method.to_s] = block
    end

    alias_method :stub_instance_method, :mock_instance_method

    def get_mock_instance_method(method)
      method_block = @mockable_instance_methods[method]
      method_block = self.class.mockable_instance_methods[method] if method_block.nil?
      self.class.is_implemented(method_block, method, '#')
      method_block
    end

    private :get_mock_instance_method

    def clear_mocked_methods
      @mockable_instance_methods.clear
    end

  end
end
end
