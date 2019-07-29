# frozen_string_literal: true

module ActiveMocker
  class MockCreator
    module Associations
      def has_many
        relation_find(:type, __method__)
      end

      def has_one
        relation_find(:type, __method__)
      end

      def belongs_to
        relation_find(:type, __method__)
      end

      def has_and_belongs_to_many
        relation_find(:type, __method__)
      end

      def relation_find(key, value)
        association_collection.select { |r| r.send(key).to_sym == value }
      end

      def association_collection
        @association_collection ||= schema_scrapper.associations.to_a
      end
    end
  end
end
