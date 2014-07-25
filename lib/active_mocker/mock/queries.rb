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

    # Deletes the records matching +conditions+ by instantiating each
    # record and calling its +delete+ method.
    #
    # ==== Parameters
    #
    # * +conditions+ - A string, array, or hash that specifies which records
    #   to destroy. If omitted, all records are destroyed.
    #
    # ==== Examples
    #
    #   PersonMock.destroy_all(status: "inactive")
    #   PersonMock.where(age: 0..18).destroy_all
    #
    # If a limit scope is supplied, +delete_all+ raises an ActiveRecord error:
    #
    #   Post.limit(100).delete_all
    #   # => ActiveMocker::Mock::Error: delete_all doesn't support limit scope
    def delete_all(conditions=nil)
      raise ActiveMocker::Mock::Error.new("delete_all doesn't support limit scope") if from_limit?
      if conditions.nil?
        to_a.map(&:delete)
        return to_a.clear
      end
      where(conditions).map { |r| r.delete }.count
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

    # Finds the first record with the given attributes, or creates a record
    # with the attributes if one is not found:
    #
    #   # Find the first user named "Penélope" or create a new one.
    #   UserMock.find_or_create_by(first_name: 'Penélope')
    #   # => #<User id: 1, first_name: "Penélope", last_name: nil>
    #
    #   # Find the first user named "Penélope" or create a new one.
    #   # We already have one so the existing record will be returned.
    #   UserMock.find_or_create_by(first_name: 'Penélope')
    #   # => #<User id: 1, first_name: "Penélope", last_name: nil>
    #
    #   # Find the first user named "Scarlett" or create a new one with
    #   # a particular last name.
    #   User.create_with(last_name: 'Johansson').find_or_create_by(first_name: 'Scarlett')
    #   # => #<User id: 2, first_name: "Scarlett", last_name: "Johansson">
    #
    # This method accepts a block, which is passed down to +create+. The last example
    # above can be alternatively written this way:
    #
    #   # Find the first user named "Scarlett" or create a new one with a
    #   # different last name.
    #   User.find_or_create_by(first_name: 'Scarlett') do |user|
    #     user.last_name = 'Johansson'
    #   end
    #   # => #<User id: 2, first_name: "Scarlett", last_name: "Johansson">
    #
    def find_or_create_by(attributes, &block)
      find_by(attributes) || create(attributes, &block)
    end

    alias_method :find_or_create_by!, :find_or_create_by

    # Like <tt>find_or_create_by</tt>, but calls <tt>new</tt> instead of <tt>create</tt>.
    def find_or_initialize_by(attributes, &block)
      find_by(attributes) || new(attributes, &block)
    end

    def limit(num)
      relation = new_relation(all.take(num))
      relation.send(:set_from_limit)
      relation
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