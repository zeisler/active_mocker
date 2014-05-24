module ActiveMocker
module Collection

  module Queries

    def delete_all
      all.map(&:delete)
    end

    def destroy_all
      delete_all
    end

    def all(options={})
      if options.has_key?(:conditions)
        where(options[:conditions])
      else
        ActiveMocker::Collection::Base.new( to_a || [] )
      end
    end

    class WhereNotChain

      def initialize(collection)
        @collection = collection
      end

      def not(options={})
        @collection.reject do |record|
          options.all? { |col, match| record.send(col) == match }
        end
      end

    end

    def where(options=nil)
      return WhereNotChain.new(all) if options.nil?
      all.select do |record|
        options.all? { |col, match| record.send(col) == match }
      end
    end

    def update_all(options)
      all.each{ |i| i.update(options)}
    end

    def limit(num)
      Relation.new(all.take(num))
    end

    def sum(key)
      values = values_by_key(key)
      values.inject { |sum, n| sum + n }
    end

    def average(key)
      values = values_by_key(key)
      total = values.inject { |sum, n| sum + n }
      BigDecimal.new(total) / BigDecimal.new(values.count)
    end

    def minimum(key)
      values_by_key(key).min_by{|i| i }
    end

    def maximum(key)
      values_by_key(key).max_by { |i| i }
    end

    private

    def values_by_key(key)
      all.map { |obj| obj.send(key) }
    end

  end

end
end

