# frozen_string_literal: true
module ActiveMocker
  class MockCreator
    module Scopes
      Method = Struct.new(:name, :arguments, :body)

      def scope_methods
        class_introspector.class_macros.select { |h| h.keys.first == :scope }.map do |h|
          a = h.values.first.first
          Method.new(a[0], ReverseParameters.new(a[1], blocks_as_values: true), nil)
        end
      end
    end
  end
end
