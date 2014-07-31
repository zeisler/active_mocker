class SubscribeUser

  attr_accessor :user

  def initialize(user: user)
    @user = user
  end

  def with_yearly
    Subscription.create(user: user, type: 'yearly')
  end

  def with_monthly
    Subscription.create(user: user, type: 'monthly')
  end

end