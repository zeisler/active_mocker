module ActiveMock

  module Queries

    def self.extended(klass)
      @extended = klass
    end

    def self.included(klass)
      @included = klass
    end

    def self.included_klass
      @included
    end

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
        @collection = collection
        @parent_class = parent_class
      end

      def not(options={})
        @parent_class.new(@collection.reject do |record|
          Find.new(record).is_of(options)
        end)
      end
    end

    def delete_all
      all.map(&:delete)
    end

    def destroy_all
      delete_all
    end

    def parent_class
      if self.try(:superclass).try(:name) == 'ActiveMock::Base'
        return "#{self.name}::Scopes::Relation".constantize if Object.const_defined?("#{self.name}::Scopes::Relation")
      end
      Queries.included_klass
    end

    def all
      parent_class.new( to_a || [] )
    end

    def where(options=nil)
      return WhereNotChain.new(all, parent_class) if options.nil?
      parent_class.new(all.select do |record|
        Find.new(record).is_of(options)
      end)
    end

    def find(ids)
      ids_array = [*ids]
      results = ids_array.map do |id|
        where(id: id).first
      end
      return parent_class.new(results) if ids.class == Array
      results.first
    end

    def update_all(options)
      all.each{ |i| i.update(options)}
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
      parent_class.new(all.take(num))
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

    def order(key)
      parent_class.new(all.sort_by { |item| item.send(key) })
    end

    def reverse_order
      parent_class.new(to_a.reverse)
    end

    private

    def values_by_key(key)
      all.map { |obj| obj.send(key) }
    end

  end

end