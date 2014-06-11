module ActiveMocker

class RecordNotFound < StandardError
end

class ReservedFieldError < StandardError
end

class IdError < StandardError
end

class FileTypeMismatchError < StandardError
end

class RejectedParams < Exception
end

class Base

  if Object.const_defined?(:ActiveModel)
    extend ActiveModel::Naming
    include ActiveModel::Conversion
  else
    def to_param
      id.present? ? id.to_s : nil
    end
  end

  class << self

    def cache_key
      if Object.const_defined?(:ActiveModel)
        model_name.cache_key
      else
        ActiveSupport::Inflector.tableize(self)
      end
    end

    def primary_key
      "id"
    end

    def field_names
      @field_names ||= []
    end

    def the_meta_class
      class << self
        self
      end
    end

    def compute_type(type_name)
      self
    end

    def pluralize_table_names
      true
    end

    def exists?(record)
      if record.id.present?
        record_index[record.id.to_s].present?
      end
    end

    def insert(record)
      @records ||= []
      record.attributes[:id] ||= next_id
      validate_unique_id(record)
      add_to_record_index({record.id.to_s => @records.length})
      @records << record
    end

    private :insert

    def next_id
      max_record = all.max { |a, b| a.id <=> b.id }
      if max_record.nil?
        1
      elsif max_record.id.is_a?(Numeric)
        max_record.id.succ
      end
    end

    def record_index
      @record_index ||= {}
    end

    private :record_index

    def reset_record_index
      record_index.clear
    end

    private :reset_record_index

    def add_to_record_index(entry)
      record_index.merge!(entry)
    end

    private :add_to_record_index

    def validate_unique_id(record)
      if record_index.has_key?(record.id.to_s)
        raise IdError.new("Duplicate ID found for record #{record.attributes.inspect}")
      end
    end

    private :validate_unique_id

    def count
      all.length
    end

    def transaction
      yield
    rescue LocalJumpError => err
      raise err
    rescue StandardError => e
        raise e
    end

    delegate :first, :last, :to => :all

    # Needed for ActiveRecord polymorphic associations
    def base_class
      ActiveMocker::Base
    end

    def create(attributes = {}, &block)
      record = new(attributes) unless block_given?
      record = new(attributes, &block) if block_given?
      record.save
      record
    end

    alias_method :create!, :create

    def find_or_create_by(attributes)
      find_by(attributes) || create(attributes)
    end

    def find_or_initialize_by(attributes)
      find_by(attributes) || new(attributes)
    end

    def delete(id)
      find(id).delete
    end

    def to_a
      @records
    end

    alias_method :destroy, :delete

    def delete_all(options=nil)
      return reset_all_records if options.nil?
      where(options).map { |r| r.delete }.count
    end

    alias_method :destroy_all, :delete_all

    def reset_all_records
      reset_record_index
      @records = []
    end

    private :reset_all_records

  end

  extend ActiveMocker::Queries

  attr_reader :attributes

  attr_reader :associations, :types

  def initialize(attributes = {}, &block)
    @types = {}
    yield self if block_given?
    attributes.each do |key, value|
      begin
        send "#{key}=", value
      rescue NoMethodError
        raise ActiveMocker::RejectedParams, "{:#{key}=>#{value.inspect}} for #{self.class.name}"
      end
    end
  end

  def delete
    self.class.send(:record_index).delete("#{self.id}")
    records = self.class.instance_variable_get(:@records)
    index = records.index(self)
    records.delete_at(index)
  end

  def update(options={})
    options.each do |method, value|
      send("#{method}=", value)
    end
  end

  def [](key)
    attributes[key]
  end

  def []=(key, val)
    attributes[key] = val
  end

  def id
    attributes[:id] ? attributes[:id] : nil
  end

  def id=(id)
    attributes[:id] = id
  end

  alias quoted_id id

  def new_record?
    !self.class.all.include?(self)
  end

  def destroyed?
    false
  end

  def persisted?
    self.class.all.map(&:id).include?(id)
  end

  def readonly?
    false
  end

  def eql?(other)
    other.instance_of?(self.class) and not id.nil? and (id == other.id)
  end

  alias == eql?

  def hash
    id.hash
  end

  def errors
    obj = Object.new

    def obj.[](key)
      []
    end

    def obj.full_messages()
      []
    end

    obj
  end

  def save(*args)
    unless self.class.exists?(self)
      self.class.send(:insert, self)
    end
    true
  end

  alias save! save

  def valid?
    true
  end

  def marked_for_destruction?
    false
  end

end
end