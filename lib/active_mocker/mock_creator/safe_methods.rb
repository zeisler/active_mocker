# frozen_string_literal: true
module ActiveMocker
  class MockCreator
    module SafeMethods
      BASE = { instance_methods: [], scopes: [], methods: [], all_methods_safe: false }.freeze

      def safe_method?(type, name)
        plural_type      = (type.to_s + "s").to_sym
        all_methods_safe = all_methods_safe?(type, name)
        return true if all_methods_safe
        return true if safe_methods[plural_type].include?(name)
        false
      end

      private

      def safe_methods
        @safe_methods ||= class_introspector.parsed_source.comments.each_with_object(BASE.dup) do |comment, hash|
          if comment.text.include?("ActiveMocker.all_methods_safe")
            hash[:all_methods_safe] = ActiveMocker.module_eval(comment.text.delete("#"))
          elsif comment.text.include?("ActiveMocker.safe_methods")
            hash.merge!(ActiveMocker.module_eval(comment.text.delete("#")))
          else
            hash
          end
        end
      end

      def all_methods_safe?(type, name)
        plural_type      = (type.to_s + "s").to_sym
        all_methods_safe = safe_methods.fetch(:all_methods_safe)
        if all_methods_safe.is_a?(Hash)
          !all_methods_safe.fetch(plural_type).include?(name)
        else
          all_methods_safe
        end
      end

      module ActiveMocker
        class << self
          def safe_methods(*arg_methods, scopes: [], instance_methods: [], class_methods: [], all_methods_safe: false)
            {
              instance_methods: arg_methods.concat(instance_methods),
              scopes:           scopes,
              methods:          class_methods,
              all_methods_safe: all_methods_safe,
            }
          end

          def all_methods_safe(except: {})
            other_keys = except.except(:instance_methods, :scopes, :class_methods)
            unless other_keys.empty?
              raise ArgumentError, "ActiveMocker.all_methods_safe arguments must only be `except: { instance_methods: [], scopes: [], class_methods: [] }`"
            end
            {
              instance_methods: except.fetch(:instance_methods, []),
              scopes:           except.fetch(:scopes, []),
              methods:          except.fetch(:class_methods, []),
            }
          end
        end
      end
    end
  end
end
