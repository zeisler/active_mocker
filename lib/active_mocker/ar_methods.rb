module ActiveMocker

  module ARMethods
    extend ActiveSupport::Concern

    included do
    end

      def mock_class_method(meth, &block)
      end

      def mock_instance_method(meth, &block)
      end
  end
end
ActiveRecord::Base.send :extend, ActiveMocker::ARMethods