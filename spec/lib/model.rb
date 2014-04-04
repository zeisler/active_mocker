class Model < ActiveRecord::Base
  include FooBar
  extend Baz
  belongs_to :company, class_name: 'PlanServiceCategory'
  has_many :users
  has_one :account
  has_and_belongs_to_many :disclosure
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def self.duper(value, *args)

  end

  scope :named, ->(name, value=nil, options={}) { }

  def foo(foobar, value)

  end

  def self.foo

  end

  def super

  end

  def self.bang!

  end

  private

  def bar

  end

end