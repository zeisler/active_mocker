module ActiveMocker
module Mock

  module Queries

    class Find

      def initialize(record)
        @record = record
      end

      def is_of(conditions={})
        conditions.all? do |col, match|
          next match.any? { |m| @record.send(col) == m } if match.is_a? Enumerable
          @record.send(col) == match
        end
      end

    end

    class WhereNotChain

      def initialize(collection, parent_class)
        @collection   = collection
        @parent_class = parent_class
      end

      def not(conditions={})
        @parent_class.call(@collection.reject do |record|
          Find.new(record).is_of(conditions)
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
    # If a limit scope is supplied, +delete_all+ raises an ActiveMocker error:
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

    alias_method :destroy_all, :delete_all

    # Returns a new relation, which is the result of filtering the current relation
    # according to the conditions in the arguments.
    #
    # === hash
    #
    # #where will accept a hash condition, in which the keys are fields and the values
    # are values to be searched for.
    #
    # Fields can be symbols or strings. Values can be single values, arrays, or ranges.
    #
    #    User.where({ name: "Joe", email: "joe@example.com" })
    #
    #    User.where({ name: ["Alice", "Bob"]})
    #
    #    User.where({ created_at: (Time.now.midnight - 1.day)..Time.now.midnight })
    #
    # In the case of a belongs_to relationship, an association key can be used
    # to specify the model if an ActiveRecord object is used as the value.
    #
    #    author = Author.find(1)
    #
    #    # The following queries will be equivalent:
    #    Post.where(author: author)
    #    Post.where(author_id: author)
    #
    # This also works with polymorphic belongs_to relationships:
    #
    #    treasure = Treasure.create(name: 'gold coins')
    #    treasure.price_estimates << PriceEstimate.create(price: 125)
    #
    #    # The following queries will be equivalent:
    #    PriceEstimate.where(estimate_of: treasure)
    #    PriceEstimate.where(estimate_of_type: 'Treasure', estimate_of_id: treasure)
    #
    # === no argument
    #
    # If no argument is passed, #where returns a new instance of WhereChain, that
    # can be chained with #not to return a new relation that negates the where clause.
    #
    #    User.where.not(name: "Jon")
    #
    # See WhereChain for more details on #not.
    def where(conditions=nil)
      return WhereNotChain.new(all, method(:new_relation)) if conditions.nil?
      new_relation(to_a.select do |record|
        Find.new(record).is_of(conditions)
      end)
    end

    # Find by id - This can either be a specific id (1), a list of ids (1, 5, 6), or an array of ids ([5, 6, 10]).
    # If no record can be found for all of the listed ids, then RecordNotFound will be raised. If the primary key
    # is an integer, find by id coerces its arguments using +to_i+.
    #
    #   Person.find(1)          # returns the object for ID = 1
    #   Person.find(1, 2, 6)    # returns an array for objects with IDs in (1, 2, 6)
    #   Person.find([7, 17])    # returns an array for objects with IDs in (7, 17)
    #   Person.find([1])        # returns an array for the object with ID = 1
    #
    # <tt>ActiveRecord::RecordNotFound</tt> will be raised if one or more ids are not found.
    def find(ids)
      results = [*ids].map do |id|
        find_by!(id: id)
      end
      return new_relation(results) if ids.class == Array
      results.first
    end

    # Updates all records with details given if they match a set of conditions supplied, limits and order can
    # also be supplied.
    #
    # ==== Parameters
    #
    # * +updates+ - A string, array, or hash.
    #
    # ==== Examples
    #
    #   # Update all customers with the given attributes
    #   Customer.update_all wants_email: true
    #
    #   # Update all books with 'Rails' in their title
    #   BookMock.where(title: 'Rails').update_all(author: 'David')
    #
    #   # Update all books that match conditions, but limit it to 5 ordered by date
    #   BookMock.where(title: 'Rails').order(:created_at).limit(5).update_all(author: 'David')
    def update_all(conditions)
      all.each { |i| i.update(conditions) }
    end

    # Updates an object (or multiple objects) and saves it.
    #
    # ==== Parameters
    #
    # * +id+ - This should be the id or an array of ids to be updated.
    # * +attributes+ - This should be a hash of attributes or an array of hashes.
    #
    # ==== Examples
    #
    #   # Updates one record
    #   Person.update(15, user_name: 'Samuel', group: 'expert')
    #
    #   # Updates multiple records
    #   people = { 1 => { "first_name" => "David" }, 2 => { "first_name" => "Jeremy" } }
    #   Person.update(people.keys, people.values)
    def update(id, attributes)
      if id.is_a?(Array)
        id.map.with_index { |one_id, idx| update(one_id, attributes[idx]) }
      else
        object = find(id)
        object.update(attributes)
        object
      end
    end

    # Finds the first record matching the specified conditions. There
    # is no implied ordering so if order matters, you should specify it
    # yourself.
    #
    # If no record is found, returns <tt>nil</tt>.
    #
    #   Post.find_by name: 'Spartacus', rating: 4
    def find_by(conditions = {})
      send(:where, conditions).first
    end

    # Like <tt>find_by</tt>, except that if no record is found, raises
    # an <tt>ActiveRecord::RecordNotFound</tt> error.
    def find_by!(conditions={})
      result = find_by(conditions)
      raise RecordNotFound if result.nil?
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

    # Count the records.
    #
    #   PersonMock.count
    #   # => the total count of all people
    #
    #   PersonMock.count(:age)
    #   # => returns the total count of all people whose age is present in database
    def count(column_name = nil)
      return all.size if column_name.nil?
      where.not(column_name => nil).size
    end

    # Specifies a limit for the number of records to retrieve.
    #
    #   User.limit(10)
    def limit(num)
      relation = new_relation(all.take(num))
      relation.send(:set_from_limit)
      relation
    end

    # Calculates the sum of values on a given column. The value is returned
    # with the same data type of the column, 0 if there's no row.
    #
    #   Person.sum(:age) # => 4562
    def sum(key)
      values = values_by_key(key)
      values.inject(0) do |sum, n|
        sum + (n || 0)
      end
    end

    # Calculates the average value on a given column. Returns +nil+ if there's
    # no row.
    #
    #   PersonMock.average(:age) # => 35.8
    def average(key)
      values = values_by_key(key)
      total = values.inject { |sum, n| sum + n }
      BigDecimal.new(total) / BigDecimal.new(values.count)
    end

    # Calculates the minimum value on a given column. The value is returned
    # with the same data type of the column, or +nil+ if there's no row.
    #
    #   Person.minimum(:age) # => 7
    def minimum(key)
      values_by_key(key).min_by { |i| i }
    end

    # Calculates the maximum value on a given column. The value is returned
    # with the same data type of the column, or +nil+ if there's no row.
    #
    #   Person.maximum(:age) # => 93
    def maximum(key)
      values_by_key(key).max_by { |i| i }
    end

    # Allows to specify an order attribute:
    #
    #   User.order('name')
    #
    #   User.order(:name)
    def order(key)
      new_relation(all.sort_by { |item| item.send(key) })
    end

    # Reverse the existing order clause on the relation.
    #
    #   User.order('name').reverse_order
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