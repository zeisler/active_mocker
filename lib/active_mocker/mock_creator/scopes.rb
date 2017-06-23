# frozen_string_literal: true
require_relative "safe_methods"
module ActiveMocker
  class MockCreator
    module Scopes
      Method = Struct.new(:name, :arguments, :body)
      include SafeMethods

      def scope_methods
        class_introspector.class_macros.select { |h| h.keys.first == :scope }.map do |h|
          name, args = h.values.first.first
          arguments  = ReverseParameters.new(args)
          body       = scope_body(arguments, name)
          Method.new(name, arguments, body)
        end
      end

      def scope_body(arguments, name)
        if safe_methods[:scopes].include?(name)
          find_scope_body_from_ast(name)
        else
          "#{class_name}.send(:call_mock_method, " \
                           "method: '#{name}', " \
                           "caller: Kernel.caller, " \
                           "arguments: [#{arguments.arguments}])"
        end
      end

      def ast_scopes
        @ast_scopes ||= class_introspector
                          .parsed_source
                          .class_begin
                          .children
                          .select { |n| n.try(:type) == :send && n.try { children[1] == :scope } }
      end

      def find_scope_body_from_ast(name)
        scope = ast_scopes.detect { |n| n.children[2].children.first == name }
        DissociatedIntrospection::RubyCode.build_from_ast(scope.children[3].children[2]).source
      end
    end
  end
end
