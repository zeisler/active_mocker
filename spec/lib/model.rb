class Model < ActiveRecord::Base

  belongs_to :company
  has_many :users
  has_one :account
  has_and_belongs_to_many :disclosure

  def self.duper(value, *args)

  end

  scope :named, ->(name, value=nil, options={}) { }

  def foo(foobar, value)

  end

  def self.foo

  end

  def super

  end

  private

  def bar

  end

end