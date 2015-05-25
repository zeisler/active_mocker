module ActiveMocker
  module Rspec

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
        return unless ActiveMocker::LoadedMocks.disable_global_state
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

  end
end