require 'active_mocker/loaded_mocks'

module ActiveMocker
  module RSpec

    class Interface

      def initialize(parent)
        @parent   = parent
        @metadata = parent.class.metadata
      end

      def mocks
        _am_mocks_with_scope
      end

      private
      attr_reader :parent, :metadata

      def _am_mocks_with_scope
        ActiveMocker::LoadedMocks.scoped_set(_am_uniq_key_for_example)
      end

      def _am_class_name_to_mock
        ActiveMocker::LoadedMocks.scoped_set(_am_uniq_key_for_example)
      end

      def _am_uniq_key_for_example
        Digest::MD5.hexdigest _am_outermost_parent_example[:location] + _am_outermost_parent_example[:full_description]
      end

      def _am_outermost_parent_example(group: metadata[:parent_example_group] || metadata)
        if group[:parent_example_group].nil?
          group
        else
          _am_outermost_parent_example(group: group[:parent_example_group])
        end
      end
    end

    def active_mocker
      Interface.new(self)
    end

    # Deprecated method, will be removed in version 2.1
    # Use +active_mocker.mocks.find('ClassName')+ instead
    def mock_class(*args)
      active_mocker.mocks.find(*args)
    end

    private

  end
end

RSpec.configure do |config|

  config.include ActiveMocker::RSpec

  config.before(:each, active_mocker: true) do
    unless ENV['RUN_WITH_RAILS'] && self.class.metadata[:rails_compatible]
      active_mocker.mocks.each { |class_name, mock| stub_const(class_name, mock) }
    end
  end

  config.after(:all,active_mocker: true) do
    if ActiveMocker::LoadedMocks.disable_global_state
      ActiveMocker::LoadedMocks.deallocate_scoped_set(active_mocker.send(:_am_uniq_key_for_example))
    else
      ActiveMocker::LoadedMocks.delete_all
    end
  end

end
