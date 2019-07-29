# frozen_string_literal: true

module ActiveMocker
  class Base
    include DoNothingActiveRecordMethods
    include TemplateMethods
    extend Queries
    extend AliasAttribute
    extend MockableMethod
    include MockableMethod

    def self.inherited(subclass)
      ActiveMocker::LoadedMocks.send(:add, subclass)
    end

    class << self
      # Creates an object (or multiple objects) and saves it to memory.
      #
      # The +attributes+ parameter can be either a Hash or an Array of Hashes. These Hashes describe the
      # attributes on the objects that are to be created.
      #
      # ==== Examples
      #   # Create a single new object
      #   User.create(first_name: 'Jamie')
      #
      #   # Create an Array of new objects
      #   User.create([{ first_name: 'Jamie' }, { first_name: 'Jeremy' }])
      #
      #   # Create a single object and pass it into a block to set other attributes.
      #   User.create(first_name: 'Jamie') do |u|
      #     u.is_admin = false
      #   end
      #
      #   # Creating an Array of new objects using a block, where the block is executed for each object:
      #   User.create([{ first_name: 'Jamie' }, { first_name: 'Jeremy' }]) do |u|
      #     u.is_admin = false
      #   end
      def create(attributes = {}, &block)
        if attributes.is_a?(Array)
          attributes.collect { |attr| create(attr, &block) }
        else
          record = new(id: attributes.delete(:id) || attributes.delete("id"))

          record.save
          record.touch(:created_at, :created_on) if ActiveMocker::LoadedMocks.features[:timestamps]
          record.assign_attributes(attributes, &block)
          record._create_caller_locations = caller_locations
          record
        end
      end

      alias create! create

      def records
        @records ||= Records.new
      end

      private :records

      delegate :insert, :exists?, :to_a, to: :records
      delegate :first, :last, to: :all

      # Delete an object (or multiple objects) that has the given id.
      #
      # This essentially finds the object (or multiple objects) with the given id and then calls delete on it.
      #
      # ==== Parameters
      #
      # * +id+ - Can be either an Integer or an Array of Integers.
      #
      # ==== Examples
      #
      #   # Destroy a single object
      #   TodoMock.delete(1)
      #
      #   # Destroy multiple objects
      #   todos = [1,2,3]
      #   TodoMock.delete(todos)
      def delete(id)
        if id.is_a?(Array)
          id.map { |one_id| delete(one_id) }
        else
          find(id).delete
        end
      end

      alias destroy delete

      # Deletes the records matching +conditions+.
      #
      #   Post.where(person_id: 5).where(category: ['Something', 'Else']).delete_all
      def delete_all(conditions = nil)
        return records.reset if conditions.nil?
        super
      end

      alias destroy_all delete_all

      # @api private
      def from_limit?
        false
      end

      def abstract_class?
        true
      end

      # rubocop:disable Style/ClassVars
      def build_type(type)
        @@built_types       ||= {}
        @@built_types[type] ||= Virtus::Attribute.build(type)
      end

      def classes(klass, fail_hard = false)
        ActiveMocker::LoadedMocks.find(klass).tap do |found_class|
          raise MockNotLoaded, "The ActiveMocker version of #{klass} is not required." if fail_hard && !found_class
          found_class
        end
      end

      # @param [Array<ActiveMocker::Base>] collection, an array of mock instances
      # @return [ScopeRelation] for the given mock so that it will include any scoped methods
      def __new_relation__(collection)
        ScopeRelation.new(collection)
      end

      private :classes, :build_type, :__new_relation__

      # @deprecated
      def clear_mock
        delete_all
      end

      def _find_associations_by_class(klass_name)
        associations_by_class[klass_name.to_s]
      end

      # Not fully Implemented
      # Returns association reflections names with nil values
      #
      #   #=> { "user" => nil, "order" => nil }
      def reflections
        associations.each_with_object({}) { |(k, _), h| h[k.to_s] = nil }
      end

      def __active_record_build_version__
        @active_record_build_version
      end

      private

      def mock_build_version(version, active_record: nil)
        @active_record_build_version = Gem::Version.create(active_record)
        if __active_record_build_version__ >= Gem::Version.create("5.1")
          require "active_mocker/mock/compatibility/base/ar51"
          extend AR51
        end

        if __active_record_build_version__ >= Gem::Version.create("5.2")
          require "active_mocker/mock/compatibility/queries/ar52"
          Queries.prepend(Queries::AR52)
        end
        raise UpdateMocksError.new(name, version, ActiveMocker::Mock::VERSION) if version != ActiveMocker::Mock::VERSION
      end
    end

    # @deprecated
    def call_mock_method(method:, caller:, **_)
      self.class.send(:is_implemented, method, "#", caller)
    end

    private :call_mock_method

    def classes(klass, fail_hard = false)
      self.class.send(:classes, klass, fail_hard)
    end

    private :classes

    attr_reader :associations, :types, :attributes
    # @private
    attr_accessor :_create_caller_locations
    # New objects can be instantiated as either empty (pass no construction parameter) or pre-set with
    # attributes.
    #
    # ==== Example:
    #   # Instantiates a single new object
    #   UserMock.new(first_name: 'Jamie')

    def initialize(attributes = {}, &block)
      if self.class.abstract_class?
        raise NotImplementedError, "#{self.class.name} is an abstract class and cannot be instantiated."
      end
      setup_instance_variables
      assign_attributes(attributes, &block)
    end

    def setup_instance_variables
      @types        = self.class.send(:types)
      @attributes   = self.class.send(:attributes).deep_dup
      @associations = self.class.send(:associations).dup
    end

    private :setup_instance_variables

    def update(attributes = {})
      assign_attributes(attributes)
      save
    end

    # Allows you to set all the attributes by passing in a hash of attributes with
    # keys matching the attribute names (which again matches the column names).
    #
    #   cat = Cat.new(name: "Gorby", status: "yawning")
    #   cat.attributes # =>  { "name" => "Gorby", "status" => "yawning", "created_at" => nil, "updated_at" => nil}
    #   cat.assign_attributes(status: "sleeping")
    #   cat.attributes # =>  { "name" => "Gorby", "status" => "sleeping", "created_at" => nil, "updated_at" => nil }
    #
    # Aliased to <tt>attributes=</tt>.
    def assign_attributes(new_attributes)
      yield self if block_given?
      unless new_attributes.respond_to?(:stringify_keys)
        raise ArgumentError, "When assigning attributes, you must pass a hash as an argument."
      end
      return nil if new_attributes.blank?
      attributes = new_attributes.stringify_keys
      attributes.each do |k, v|
        _assign_attribute(k, v)
      end
    end

    alias attributes= assign_attributes

    # @api private
    def _assign_attribute(k, v)
      public_send("#{k}=", v)
    rescue NoMethodError
      if respond_to?("#{k}=")
        raise
      else
        raise UnknownAttributeError.new(self, k)
      end
    end

    def save(*_args)
      self.class.send(:insert, self) unless self.class.exists?(self)
      touch if ActiveMocker::LoadedMocks.features[:timestamps]
      true
    end

    alias save! save

    def touch(*names)
      raise ActiveMocker::Error, "cannot touch on a new record object" unless persisted?

      attributes = %i[updated_at update_on]
      attributes.concat(names)

      current_time = Time.now.utc

      attributes.each do |column|
        column = column.to_s
        write_attribute(column, current_time) if self.class.attribute_names.include?(column)
      end
      true
    end

    def records
      self.class.send(:records)
    end

    private :records

    def delete
      records.delete(self)
    end

    alias destroy delete

    delegate :[], :[]=, to: :attributes

    # Returns true if this object hasn't been saved yet; otherwise, returns false.
    def new_record?
      records.new_record?(self)
    end

    # Indicates if the model is persisted. Default is +false+.
    #
    #  person = Person.new(id: 1, name: 'bob')
    #  person.persisted? # => false
    def persisted?
      records.persisted?(id)
    end

    # Returns +true+ if the given attribute is in the attributes hash, otherwise +false+.
    #
    #   person = Person.new
    #   person.has_attribute?(:name)    # => true
    #   person.has_attribute?('age')    # => true
    #   person.has_attribute?(:nothing) # => false
    def has_attribute?(attr_name)
      @attributes.key?(attr_name.to_s)
    end

    # Returns +true+ if the specified +attribute+ has been set and is neither +nil+ nor <tt>empty?</tt> (the latter only applies
    # to objects that respond to <tt>empty?</tt>, most notably Strings). Otherwise, +false+.
    # Note that it always returns +true+ with boolean attributes.
    #
    #   person = Task.new(title: '', is_done: false)
    #   person.attribute_present?(:title)   # => false
    #   person.attribute_present?(:is_done) # => true
    #   person.name = 'Francesco'
    #   person.is_done = true
    #   person.attribute_present?(:title)   # => true
    #   person.attribute_present?(:is_done) # => true
    def attribute_present?(attribute)
      value = read_attribute(attribute)
      !value.nil? && !(value.respond_to?(:empty?) && value.empty?)
    end

    # Returns a hash of the given methods with their names as keys and returned values as values.
    def slice(*methods)
      Hash[methods.map! { |method| [method, public_send(method)] }].with_indifferent_access
    end

    # Returns an array of names for the attributes available on this object.
    #
    #   person = Person.new
    #   person.attribute_names
    #   # => ["id", "created_at", "updated_at", "name", "age"]
    def attribute_names
      self.class.attribute_names
    end

    def inspect
      ObjectInspect.new(name, attributes).to_s
    end

    # Will not allow attributes to be changed
    #
    # Will freeze attributes forever. Querying for the record again will not unfreeze it because records exist in memory
    # and are not initialized upon a query. This behaviour differs from ActiveRecord, beware of any side effect this may
    # have when using this method.
    def freeze
      @attributes.freeze; self
    end

    def name
      self.class.name
    end

    private :name

    module PropertiesGetterAndSetter
      # Returns the value of the attribute identified by <tt>attr_name</tt> after
      # it has been typecast (for example, "2004-12-12" in a date column is cast
      # to a date object, like Date.new(2004, 12, 12))
      def read_attribute(attr)
        @attributes[attr]
      end

      # Updates the attribute identified by <tt>attr_name</tt> with the
      # specified +value+. Empty strings for fixnum and float columns are
      # turned into +nil+.
      def write_attribute(attr, value)
        @attributes[attr] = types[attr].coerce(value)
      end

      # @api private
      def read_association(attr, assign_if_value_nil = nil)
        @associations[attr.to_sym] ||= assign_if_value_nil.try(:call)
      end

      # @api private
      def write_association(attr, value)
        @associations[attr.to_sym] = value
      end

      protected :read_association, :write_association
    end

    include PropertiesGetterAndSetter

    class ScopeRelation < Association
    end

    module Scopes
    end
  end
end
