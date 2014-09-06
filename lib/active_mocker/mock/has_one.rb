module ActiveMocker
  module Mock

    class HasOne

      attr_reader :item

      def initialize(item, child_self:, foreign_key:, foreign_id:)
        @item = item
        item.send(:write_attribute, foreign_key, foreign_id) if item.respond_to?("#{foreign_key}=") && !foreign_id.nil?
        has_many = child_self.class.send('mocked_class').tableize
        has_one  = child_self.class.send('mocked_class').tableize.singularize
        item.send(has_many) << child_self  if item.respond_to?("#{has_many}=") && !item.send(has_many).include?(child_self)
        item.send(:write_association, has_one, child_self) if item.respond_to?("#{has_one}=")
      end

    end

  end
end

