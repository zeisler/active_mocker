# frozen_string_literal: true
module ActiveMocker
  class MockCreator
    module SafeMethods
      BASE = { instance_methods: [], scopes: [], methods: [] }.freeze

      def safe_methods
        @safe_methods ||= class_introspector.parsed_source.comments.each_with_object(BASE.dup) do |comment, hash|
          if comment.text.include?("ActiveMocker.safe_methods")
            hash.merge!(ActiveMocker.module_eval(comment.text.delete("#")))
          else
            hash
          end
        end
      end

      module ActiveMocker
        def self.safe_methods(*arg_methods, scopes: [], instance_methods: [], class_methods: [])
          { instance_methods: arg_methods.concat(instance_methods), scopes: scopes, methods: class_methods }
        end
      end
    end
  end
end
