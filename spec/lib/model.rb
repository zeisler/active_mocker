class Model < ActiveRecord::Base
  MY_CONSTANT_VALUE = 3
  module FooBar
  end

  # include FooBar
  # extend Baz
  include PostMethods
  # include ModelCore::PlanService::Dah

  belongs_to :company, class_name: 'PlanServiceCategory', foreign_key: 'category_id'
  belongs_to :person, through: 'customer'
  has_many :users
  has_one :account
  has_and_belongs_to_many :disclosures
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def self.duper(value, *args)

  end

  scope :named, ->(name, value=nil, options={}) { }
  scope :other_named, -> { }

  def foo(foobar, value)

  end

  def self.foo

  end

  def superman

  end

  def self.bang!

  end

  private

  def bar

  end

end