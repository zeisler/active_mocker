module ActiveMocker
  module TemplateMethods

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods

      def attributes
        HashWithIndifferentAccess.new({})
      end

      def associations
        {}
      end

      def associations_by_class
        {}
      end

      def mocked_class
        ''
      end

      def attribute_names
        []
      end

      def primary_key
        ''
      end

    end
  end
end
