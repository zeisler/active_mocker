require 'ostruct'

module Relationships

  def relationships
    OpenStruct.new({has_many:   @has_many   ||= [],
                    has_one:    @has_one    ||= [],
                    belongs_to: @belongs_to ||= [],
                    has_and_belongs_to_many: @has_and_belongs_to_many ||= []})
  end

  private

  def has_many(*args)
    @has_many ||= []
    @has_many.push args
  end

  def has_one(*args)
    @has_one ||= []
    @has_one.push args
  end

  def belongs_to(*args)
    @belongs_to ||= []
    @belongs_to.push args
  end

  def has_and_belongs_to_many(*args)
    @has_and_belongs_to_many ||= []
    @has_and_belongs_to_many.push args
  end

end