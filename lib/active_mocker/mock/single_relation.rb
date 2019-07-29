# frozen_string_literal: true

module ActiveMocker
  class SingleRelation
    attr_reader :item

    def initialize(item, child_self:, **_)
      @item = item
      assign_associations(child_self, item) if item.class <= Base
    end

    def assign_associations(child_self, item)
      [*item.class._find_associations_by_class(child_self.class.send("mocked_class"))].each do |_type, relations|
        relations.each do |relation|
          if item.send(relation).class <= Collection
            item.send(relation) << child_self
          else
            item.send(:write_association, relation, child_self)
          end
        end
      end
    end
  end
end
