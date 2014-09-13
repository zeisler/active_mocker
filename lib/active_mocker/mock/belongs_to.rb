module ActiveMocker
  module Mock

    class BelongsTo < SingleRelation

      attr_reader :item

      def initialize(item, child_self:, foreign_key:, foreign_id:)
        child_self.send(:write_attribute, foreign_key, foreign_id) if item.try(:persisted?)
        super
      end

    end

  end
end

