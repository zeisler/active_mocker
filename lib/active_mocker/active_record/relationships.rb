require 'ostruct'

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

  private

  def has_many(*args)
    @has_many ||= []
    @has_many.push [args.first]
  end

  def has_one(*args)
    @has_one ||= []
    @has_one.push [args.first]
  end

  def belongs_to(*args)
    @belongs_to ||= []
    @belongs_to.push [args.first]
  end

  def has_and_belongs_to_many(*args)
    @has_and_belongs_to_many ||= []
    @has_and_belongs_to_many.push [args.first]
  end

end