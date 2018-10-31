# frozen_string_literal: true
# # ActiveMocker.all_methods_safe
class Account < ActiveRecord::Base
  belongs_to :user

  def safe
    :hello
  end
end
