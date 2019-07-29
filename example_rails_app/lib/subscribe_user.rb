# frozen_string_literal: true

class SubscribeUser
  attr_accessor :user

  def initialize(user: user)
    @user = user
  end

  def with_yearly
    Subscription.create(user: user, kind: "yearly")
  end

  def with_monthly
    Subscription.create(user: user, kind: "monthly")
  end
end
