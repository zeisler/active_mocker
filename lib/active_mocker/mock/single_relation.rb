module ActiveMocker
  module Mock

    class SingleRelation

      attr_reader :item

      def initialize(item, child_self:, foreign_key:, foreign_id:)
        @item = item
        assign_associations(child_self, item)
      end

      def assign_associations(child_self, item)
        has_many = child_self.class.send('mocked_class').tableize
        has_one = child_self.class.send('mocked_class').tableize.singularize
        item.send(has_many) << child_self if item.respond_to?("#{has_many}=") && !item.send(has_many).include?(child_self)
        item.send(:write_association, has_one, child_self) if item.respond_to?("#{has_one}=")
      end

    end

  end
end

