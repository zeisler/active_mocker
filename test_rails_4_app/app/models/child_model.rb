# frozen_string_literal: true
class ChildModel < User
  has_many :accounts

  scope :by_credits, -> (credits) { where(credits: credits) }
  scope :i_take_a_block, -> () { where(credits: credits) }

  def child_method
  end
end
