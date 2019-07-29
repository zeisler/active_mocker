# frozen_string_literal: true

require "virtus"

module ActiveMocker
  module AttributeTypes
    class Enum < Virtus::Attribute
      class << self
        def build(db_value_type:, table_name:, attribute:, enums:, ignore_value: false)
          klass               = Class.new(ActiveMocker::AttributeTypes::Enum)
          klass.table_name    = table_name.to_sym
          klass.attribute     = attribute.to_sym
          klass.ignore_value  = ignore_value
          enums               = if enums.is_a?(Array)
                                  enums.each_with_object({}).with_index { |(k, h), i| h[k] = i }
                                else
                                  enums
                                end
          klass.key_type      = String
          klass.db_value_type = db_value_type
          klass.enums         = Hash[enums.map do |k, v|
            [Virtus::Attribute.build(klass.key_type).coerce(k),
             Virtus::Attribute.build(klass.db_value_type).coerce(v)]
          end]
          klass
        end

        def to_s
          <<~RUBY
            ActiveMocker::AttributeTypes::Enum.build(
              ignore_value: #{ignore_value},
              db_value_type: #{db_value_type},
              table_name: :#{table_name},
              attribute: :#{attribute},
              enums: #{enums.inspect}
            )
          RUBY
        end

        attr_accessor :enums, :table_name, :attribute, :db_value_type, :key_type, :ignore_value
      end

      def coerce(key)
        return if key.nil?
        coerced_key = key_type.coerce(key)
        key_not_valid!(coerced_key) unless key && self.class.enums.key?(coerced_key)
        if self.class.ignore_value
          coerced_key
        else
          get_value(key)
        end
      end

      def get_key(value)
        self.class.enums.invert[db_value_type.coerce(value)]
      end

      def get_value(key)
        self.class.enums[key_type.coerce(key)]
      end

      def key_type
        Virtus::Attribute.build(self.class.key_type)
      end

      def db_value_type
        Virtus::Attribute.build(self.class.db_value_type)
      end

      private

      def key_not_valid!(coerced_key)
        raise ArgumentError, "'#{coerced_key}' is not a valid #{self.class.attribute}"
      end
    end
  end
end
