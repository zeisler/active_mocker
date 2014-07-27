class Account < ActiveRecord::Base
  has_one :user
end
