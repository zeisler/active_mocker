module ActiveMocker
  class MockCreator
    module Attributes
      def attributes
        @attributes ||= begin
          a = schema_scrapper.attributes.to_a
          a << primary_key unless a.any? { |aa| aa.name == "id" }
          a.map(&method(:process_attr))
          a
        end
      end

      def process_attr(attr)
        enums                 = enums(attr.name)
        attr.default          = Virtus::Attribute.build(attr.type).coerce(attr.default)
        attr.attribute_writer = "write_attribute(:#{attr.name}, val)"
        attr.attribute_reader = "read_attribute(:#{attr.name})"

        unless enums.empty?
          enum_type = ActiveMocker::AttributeTypes::Enum.build(
            enums:         enums,
            table_name:    table_name,
            attribute:     attr.name,
            db_value_type: attr.type,
          )
          if ActiveRecord::VERSION::MAJOR == 5
            enum_type.ignore_value = true
            attr.type              = enum_type
            if attr.default
              attr.default = Virtus::Attribute.build(enum_type).get_key(attr.default)
            end
          elsif ActiveRecord::VERSION::MAJOR == 4
            attr.attribute_writer = "@#{attr.name}_enum_type ||= Virtus::Attribute.build(#{enum_type})\nwrite_attribute(:#{attr.name}, @#{attr.name}_enum_type.coerce(val))"
            attr.attribute_reader = "@#{attr.name}_enum_type ||= Virtus::Attribute.build(#{enum_type})\n@#{attr.name}_enum_type.get_key(read_attribute(:#{attr.name}))"
            if attr.default
              attr.default = Virtus::Attribute.build(attr.type).coerce(attr.default)
            end
          end
          attr
        end
      end

      def enums(attribute)
        @enums ||= begin
          raw_enums = class_introspector
                        .class_macros
                        .select { |hash| hash.key?(:enum) }
          if raw_enums
            raw_enums
              .map { |hash| hash[:enum].flatten.first }
              .each_with_object({}) { |v, h| h.merge!(v) }
          else
            {}
          end
        end

        @enums.fetch(attribute.to_sym, {})
      end
    end
  end
end
