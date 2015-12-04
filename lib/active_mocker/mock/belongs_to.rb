module ActiveMocker
  class BelongsTo < SingleRelation
    attr_reader :item

    def initialize(item, child_self:, foreign_key:)
      save_item(item, child_self)
      assign_foreign_key(child_self, foreign_key, item.try(:id))
      super
    end

    private

    def assign_foreign_key(child_self, foreign_key, foreign_id)
      child_self.send(:write_attribute, foreign_key, foreign_id)
    end

    def save_item(item, child_self)
      return if item.nil?
      item.try(:save) if child_self.persisted?
    end
  end
end

