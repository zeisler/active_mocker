# frozen_string_literal: true
module ActiveMocker
  class MockRelation
    # @param [ActiveMocker::Base] mock, a generated mock class
    # @param [Array<ActiveMocker::Base>] collection, an array of mock instances
    # @return [ScopeRelation] for the given mock
    def self.new(mock, collection)
      mock.send(:__new_relation__, collection)
    end
  end
end
