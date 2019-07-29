# frozen_string_literal: true

module ActiveMocker
  class MockCreator
    module RecreateClassMethodCalls
      AliasAttributeMethod = Struct.new(:new_name, :old_name)

      def class_method_calls
        @class_method_calls ||= class_introspector
                                  .class_macros
                                  .select { |h| h.keys.first == :alias_attribute }
                                  .map do |h|
          a = h.values.first.first
          AliasAttributeMethod.new(a[0].to_s, a[1].to_s)
        end
      end

      def attribute_aliases
        class_method_calls.each_with_object({}) do |alias_attr, hash|
          hash[alias_attr.new_name] = alias_attr.old_name
        end
      end
    end
  end
end
