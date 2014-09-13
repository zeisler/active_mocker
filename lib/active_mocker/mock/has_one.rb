module ActiveMocker
  module Mock

    class HasOne < SingleRelation

      attr_reader :item

      def initialize(item, child_self:, foreign_key:, foreign_id:)
        item.send(:write_attribute, foreign_key, foreign_id) if item.respond_to?("#{foreign_key}=") && !foreign_id.nil?
        super
      end

    end

  end
end

