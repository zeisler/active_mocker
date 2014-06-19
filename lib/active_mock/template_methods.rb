module ActiveMock
  module TemplateMethods

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods

      def attributes
        raise ActiveMock::Unimplemented
      end

      def types
        raise ActiveMock::Unimplemented
      end

      def associations
        raise ActiveMock::Unimplemented
      end

      def mocked_class
        raise ActiveMock::Unimplemented
      end

      def attribute_names
        raise ActiveMock::Unimplemented
      end

      def primary_key
        raise ActiveMock::Unimplemented
      end

    end

  end
end
