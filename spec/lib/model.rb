class Model < ActiveRecord::Base

  belongs_to :company
  has_many :users
  has_one :account
  has_and_belongs_to_many :disclosure

  def self.duper

  end

  scope :named, -> { }

  def foo

  end

  def super

  end

  private

  def bar

  end

end