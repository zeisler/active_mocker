class ChildModel < User

  has_many :accounts

  scope :by_credits, -> (credits) { where(credits: credits) }

  def child_method

  end

end
