module ActiveMocker
  module Mock
    class MockRelation

      # @param [ActiveMocker::Mock::Base] mock, a generated mock class
      # @param [Array<ActiveMocker::Mock::Base>] collection, an array of mock instances
      # @return [ScopeRelation] for the given mock
      def self.new(mock, collection)
        mock.send(:__new_relation__, collection)
      end

    end
  end
end
