# frozen_string_literal: true
module ActiveMocker
  class MockCreator
    module Scopes
      Method = Struct.new(:name, :arguments, :body)

      def scope_methods
        class_introspector.class_macros.select { |h| h.keys.first == :scope }.map do |h|
          name, args = h.values.first.first
          arguments  = ReverseParameters.new(args, blocks_as_values: true)
          Method.new(
            name,
            arguments,
            "#{class_name}.send(:call_mock_method, method: '#{name}', caller: Kernel.caller, arguments: [#{arguments.arguments}])"
          )
        end
      end
    end
  end
end
