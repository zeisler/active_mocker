require_relative "attributes"

module ActiveMocker
  class MockCreator
    module ClassMethods
      include Attributes

      def attributes_with_defaults
        types_hash
        attributes.each_with_object({}) do |attr, hash|
          hash[attr.name] = attr.default
        end
      end

      def types_hash
        @types_hash ||= attributes.each_with_object(HashNewStyle.new) do |attr, types|
          types[attr.name] = attr.type.to_s
        end.inspect
      end

      def associations
        @associations ||= schema_scrapper.associations.to_a.each_with_object({}) do |a, h|
          h[a.name] = nil
        end
      end

      def associations_by_class
        schema_scrapper.associations.to_a.each_with_object({}) do |r, hash|
          hash[r.class_name.to_s]         ||= {}
          hash[r.class_name.to_s][r.type] ||= []
          hash[r.class_name.to_s][r.type] << r.name
        end
      end

      def attribute_names
        attributes.map(&:name)
      end

      def abstract_class
        schema_scrapper.abstract_class?
      end

      def table_name
        schema_scrapper.table_name
      end

      def mocked_class
        [nested_modules, class_name].compact.reject(&:empty?).join("::")
      end
    end
  end
end
