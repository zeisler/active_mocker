module ActiveMocker
  module Rspec

    # @return ActiveMocker::LoadedMocks
    def active_mocker
      ActiveMocker::LoadedMocks
    end

    # @deprecated method, will be removed in version 2.1
    # Use +active_mocker.mocks.find('ClassName')+ instead
    def mock_class(*args)
      active_mocker.mocks.find(*args)
    end

  end
end