module ActiveMocker
  module Mock

    class HasOne < SingleRelation

      attr_reader :item

      def initialize(item, child_self:, foreign_key:)
        item.send(:write_attribute, foreign_key, item.try(:id)) if !item.try(:id).nil?
        super
      end

    end

  end
end

