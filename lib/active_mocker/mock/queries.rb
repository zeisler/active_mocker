module ActiveMocker
module Mock

  module Queries

    class Find

      def initialize(record)
        @record = record
      end

      def is_of(options={})
        options.all? do |col, match|
          next match.any? { |m| @record.send(col) == m } if match.class == Array
          @record.send(col) == match
        end
      end

    end

    class WhereNotChain

      def initialize(collection, parent_class)
        @collection   = collection
        @parent_class = parent_class
      end

      def not(options={})
        @parent_class.call(@collection.reject do |record|
          Find.new(record).is_of(options)
        end)
      end
    end

    def delete_all(options=nil)
      if options.nil?
        to_a.map(&:delete)
        return to_a.clear
      end
      where(options).map { |r| r.delete }.count
    end

    def destroy_all
      delete_all
    end

    def where(options=nil)
      return WhereNotChain.new(all, method(:new_relation)) if options.nil?
      new_relation(to_a.select do |record|
        Find.new(record).is_of(options)
      end)
    end

    def find(ids)
      results = [*ids].map do |id|
        where(id: id).first
      end
      return new_relation(results) if ids.class == Array
      results.first
    end

    def update_all(options)
      all.each { |i| i.update(options) }
    end

    def find_by(options = {})
      send(:where, options).first
    end

    def find_by!(options={})
      result = find_by(options)
      raise RecordNotFound if result.blank?
      result
    end

    def limit(num)
      new_relation(all.take(num))
    end

    def sum(key)
      values = values_by_key(key)
      values.inject(0) do |sum, n|
        sum + (n || 0)
      end
    end

    def average(key)
      values = values_by_key(key)
      total = values.inject { |sum, n| sum + n }
      BigDecimal.new(total) / BigDecimal.new(values.count)
    end

    def minimum(key)
      values_by_key(key).min_by { |i| i }
    end

    def maximum(key)
      values_by_key(key).max_by { |i| i }
    end

    def order(key)
      new_relation(all.sort_by { |item| item.send(key) })
    end

    def reverse_order
      new_relation(to_a.reverse)
    end

    def all
      new_relation(to_a || [])
    end

    private

    def values_by_key(key)
      all.map { |obj| obj.send(key) }
    end

    def new_relation(collection)
      duped = self.dup
      duped.collection = collection
      duped
    end

  end

  end
end