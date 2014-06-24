module ActiveMocker
module Mock
  module TemplateMethods

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods

      def attributes
        raise Mock::Unimplemented
      end

      def types
        raise Mock::Unimplemented
      end

      def associations
        raise Mock::Unimplemented
      end

      def mocked_class
        raise Mock::Unimplemented
      end

      def attribute_names
        raise Mock::Unimplemented
      end

      def primary_key
        raise Mock::Unimplemented
      end

    end

  end
end
end
