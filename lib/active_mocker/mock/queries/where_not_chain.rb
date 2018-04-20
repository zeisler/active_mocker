module ActiveMocker
  module Queries
    class WhereNotChain
      def initialize(collection, parent_class)
        @collection   = collection
        @parent_class = parent_class
      end

      def not(conditions = {})
        @parent_class.call(@collection.reject do |record|
          Find.new(record).is_of(conditions)
        end)
      end
    end
  end
end
