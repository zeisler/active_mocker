module ActiveMocker
module Mock
class Base

  include DoNothingActiveRecordMethods
  include MockAbilities
  include TemplateMethods
  extend  Queries

  def self.inherited(subclass)
    return ActiveMocker::LoadedMocks.send(:add, subclass) if subclass.superclass == Base
    ActiveMocker::LoadedMocks.send(:add_subclass, subclass)
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
        record = new
        record.save
        record.assign_attributes(attributes, &block)
        record
      end
    end

    alias_method :create!, :create

    def records
      @records ||= Records.new
    end

    private :records

    delegate :insert, :exists?, :to_a, :to => :records
    delegate :first, :last, :to => :all

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

    alias_method :destroy, :delete

    # Deletes the records matching +conditions+.
    #
    #   Post.where(person_id: 5).where(category: ['Something', 'Else']).delete_all
    def delete_all(conditions=nil)
      return records.reset if conditions.nil?
      super
    end

    alias_method :destroy_all, :delete_all

    # @api private
    def from_limit?
      false
    end

    def build_type(type)
      @@built_types ||= {}
      @@built_types[type] ||= Virtus::Attribute.build(type)
    end

    def classes(klass)
      ActiveMocker::LoadedMocks.find(klass)
    end

    def new_relation(collection)
      ScopeRelation.new(collection)
    end

    private :classes, :build_type, :new_relation

    public

    def clear_mock
      clear_mocked_methods
      delete_all
    end

  end

  def classes(klass)
    self.class.send(:classes, klass)
  end

  private :classes

  attr_reader :associations, :types, :attributes

  # New objects can be instantiated as either empty (pass no construction parameter) or pre-set with
  # attributes but not yet saved (pass a hash with key names matching the associated table column names).
  # In both instances, valid attribute keys are determined by the column names of the associated table --
  # hence you can't have attributes that aren't part of the table columns.
  #
  # ==== Example:
  #   # Instantiates a single new object
  #   UserMock.new(first_name: 'Jamie')
  def initialize(attributes = {}, &block)
    setup_instance_variables
    assign_attributes(attributes, &block)
  end

  def setup_instance_variables
    @types        = self.class.send(:types)
    @attributes   = self.class.send(:attributes).dup
    @associations = self.class.send(:associations).dup
  end

  private :setup_instance_variables

  def update(attributes={})
    assign_attributes(attributes)
  end

  # @api private
  def assign_attributes(new_attributes, &block)
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

  def save(*args)
    unless self.class.exists?(self)
      self.class.send(:insert, self)
    end
    true
  end

  alias save! save

  def records
    self.class.send(:records)
  end

  private :records


  def delete
    records.delete(self)
  end

  alias_method :destroy, :delete

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
    @attributes.has_key?(attr_name.to_s)
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

  # Returns an array of names for the attributes available on this object.
  #
  #   person = Person.new
  #   person.attribute_names
  #   # => ["id", "created_at", "updated_at", "name", "age"]
  def attribute_names
    self.class.attribute_names
  end

  def inspect
    ObjectInspect.new(self.class.name, attributes).to_s
  end

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
    def read_association(attr)
      @associations[attr]
    end

    # @api private
    def write_association(attr, value)
      @associations[attr] = value
    end

    protected :read_attribute, :write_attribute, :read_association, :write_association

  end

  include PropertiesGetterAndSetter

  class ScopeRelation < ::ActiveMocker::Mock::Association
  end

end

def self.config
  @config ||= Config.new
end

class Config
  attr_accessor :experimental
end

end
end