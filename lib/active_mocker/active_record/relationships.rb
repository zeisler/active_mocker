require 'ostruct'
require 'active_support/core_ext/string'
module Relationships

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    attr_reader :has_and_belongs_to_many, :belongs_to, :has_one, :has_many
  end

  def relationships
    OpenStruct.new({has_many:   @has_many   ||= [],
                    has_one:    @has_one    ||= [],
                    belongs_to: @belongs_to ||= [],
                    has_and_belongs_to_many: @has_and_belongs_to_many ||= []})
  end

  def single_relationships
    belongs_to + has_one
  end

  def collections
    has_and_belongs_to_many + has_many
  end

  class Relationship
    attr_reader :name
    def initialize(name, options={})
      @name = name
      @options = options.reduce(HashWithIndifferentAccess.new, :merge)
    end

    def options
      @options.symbolize_keys
    end

    def through
      options[:through]
    end

    def class_name
      options[:class_name] || name.to_s.camelize
    end

    def foreign_key
      options[:foreign_key] || name.to_s.foreign_key
    end
  end

  class HasMany < Relationship
  end

  def has_many(*args)
    @has_many ||= []
    @has_many.push HasMany.new(args.shift, args)
  end

  class HasOne < Relationship
  end

  def has_one(*args)
    @has_one ||= []
    @has_one.push HasOne.new(args.shift, args)
  end

  class BelongsTo < Relationship
  end

  def belongs_to(*args)
    @belongs_to ||= []
    @belongs_to.push BelongsTo.new(args.shift, args)
  end


  class HasAndBelongsToMany < Relationship
  end

  def has_and_belongs_to_many(*args)
    @has_and_belongs_to_many ||= []
    @has_and_belongs_to_many.push HasAndBelongsToMany.new(args.shift, args)
  end

end