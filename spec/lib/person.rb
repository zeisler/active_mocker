# frozen_string_literal: true
class Person < ActiveRecord::Base
  belongs_to :zip_code

  def full_name
    "#{first_name} #{last_name}"
  end
end
