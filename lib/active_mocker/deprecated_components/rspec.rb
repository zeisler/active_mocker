require "active_mocker/rspec"

module ActiveMocker
  module Rspec
    # @deprecated method, will be removed in version 2.1
    # Use +active_mocker.mocks.find('ClassName')+ instead
    # To keep using until removal, require this file.
    def mock_class(*args)
      active_mocker.mocks.find(*args)
    end
  end
end