# frozen_string_literal: true
require_relative "safe_methods"
require "dissociated_introspection/method_call"

module ActiveMocker
  class MockCreator
    module Scopes
      Method = Struct.new(:name, :arguments, :body)
      include SafeMethods

      def scope_methods
        class_introspector.class_macros.select { |h| h.keys.first == :scope }.map do |h|
          name, args = h.values.first.first
          arguments  = ReverseParameters.new(args, blocks_as_values: true)
          body       = scope_body(arguments, name)
          Method.new(name, arguments, body)
        end
      end

      def scope_body(arguments, name)
        if safe_methods[:scopes].include?(name)
          class_introspector.parsed_source.class_method_calls.detect { |m| m.name == :scope && m.arguments.first == name }.arguments.last.body.source
        else
          "#{class_name}.send(:call_mock_method, " \
                           "method: '#{name}', " \
                           "caller: Kernel.caller, " \
                           "arguments: [#{arguments.arguments}])"
        end
      end
    end
  end
end
