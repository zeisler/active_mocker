# frozen_string_literal: true

module ActiveMocker
  class MockCreator
    module MockBuildVersion
      def mock_build_version
        "mock_build_version #{ActiveMocker::Mock::VERSION.inspect}, active_record: '#{ActiveRecord::VERSION::MAJOR}.#{ActiveRecord::VERSION::MINOR}'"
      end
    end
  end
end
