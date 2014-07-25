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

    def create(attributes = {}, &block)
      record = new
      record.save
      record.send(:set_properties, attributes) unless block_given?
      record.send(:set_properties_block, attributes, &block) if block_given?
      record
    end

    alias_method :create!, :create

    def records
      @records ||= Records.new
    end

    private :records

    delegate :count, :insert, :exists?, :to_a, :to => :records
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

    def delete_all(options=nil)
      return records.reset if options.nil?
      super
    end

    alias_method :destroy_all, :delete_all

    def from_limit?
      false
    end

    def build_type(type)
      Virtus::Attribute.build(type)
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

  def initialize(attributes = {}, &block)
    setup_instance_variables
    set_properties_block(attributes, &block)
  end

  def setup_instance_variables
    @types        = self.class.send(:types)
    @attributes   = self.class.send(:attributes).dup
    @associations = self.class.send(:associations).dup
  end

  private :setup_instance_variables

  def set_properties_block(attributes = {}, &block)
    yield self if block_given?
    set_properties(attributes)
  end
  private :set_properties_block

  def update(attributes={})
    set_properties(attributes)
  end

  def set_properties(attributes={})
    attributes.each do |key, value|
      begin
        send "#{key}=", value
      rescue NoMethodError
        raise RejectedParams, "{:#{key}=>#{value.inspect}} for #{self.class.name}"
      end
    end
  end

  private :set_properties

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

  def reload
    self
  end

  def new_record?
    !records.new_record?(self)
  end

  def persisted?
    records.persisted?(id)
  end

  def to_hash
    attributes
  end

  def inspect
    ObjectInspect.new(self.class.name, attributes).to_s
  end

  def hash
    attributes.hash
  end

  def ==(obj)
    return false if obj.nil?
    return hash == obj.attributes.hash if obj.respond_to?(:attributes)
    hash == obj.hash if obj.respond_to?(:hash)
  end

  module PropertiesGetterAndSetter

    def read_attribute(attr)
      @attributes[attr]
    end

    def write_attribute(attr, value)
      @attributes[attr] = types[attr].coerce(value)
    end

    def read_association(attr)
      @associations[attr]
    end

    def write_association(attr, value)
      @associations[attr] = value
    end

    protected :read_attribute, :write_attribute, :read_association, :write_association

  end

  include PropertiesGetterAndSetter

  class ScopeRelation < ::ActiveMocker::Mock::Association
  end
end
end
end