# frozen_string_literal: true
# ActiveMocker.safe_methods :superman, scopes: [:named], instance_methods: [:foo], class_methods: [:bang!, :foo]
class Model < ActiveRecord::Base
  MY_CONSTANT_VALUE = 3
  MY_OBJECT = Object.new
  module FooBar
  end

  include FooBar
  # extend Baz
  include PostMethods
  # include ModelCore::PlanService::Dah

  belongs_to :company, class_name: "PlanServiceCategory", foreign_key: "category_id"
  belongs_to :person, through: "customer"
  has_many :users
  has_one :account
  has_and_belongs_to_many :disclosures
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable

  def self.duper(value, *args)
  end

  scope :named, ->(name, value = nil, options = {}) { 2 + 2}
  scope :other_named, -> { 1 + 1}
  alias_attribute :full_name, :name
  def foo(foobar, value)
  end

  class << self
    def foo
      :buz
    end
  end

  def superman
    __method__
  end

  def self.bang!
    :boom!
  end

  private

  def bar
  end
end
