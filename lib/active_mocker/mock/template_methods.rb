module ActiveMocker
module Mock
  module TemplateMethods

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods

      def attributes
        HashWithIndifferentAccess.new({})
      end

      def types
        ActiveMocker::Mock::HashProcess.new({}, method(:build_type))
      end

      def associations
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
end
