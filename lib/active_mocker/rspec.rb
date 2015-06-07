module ActiveMocker
  module Rspec

    class Interface

      def initialize(parent)
        @parent   = parent
        @metadata = parent.class.metadata
      end

      def mocks
        ActiveMocker::LoadedMocks.class_name_to_mock
      end

      private
      attr_reader :parent, :metadata

    end

    def active_mocker
      Interface.new(self)
    end

    # Deprecated method, will be removed in version 2.1
    # Use +active_mocker.mocks.find('ClassName')+ instead
    def mock_class(*args)
      active_mocker.mocks.find(*args)
    end

  end
end