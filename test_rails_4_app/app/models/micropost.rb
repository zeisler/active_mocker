# frozen_string_literal: true
require "#{Rails.root}/lib/post_methods"

class Micropost < ActiveRecord::Base
  require "#{Rails.root}/app/models/mircopost/core"
  belongs_to :user
  default_scope -> { order("created_at DESC") }
  MAGIC_ID_NUMBER = 90
  MAGIC_ID_STRING = "F-1"

  include PostMethods
  extend PostMethods
  include Core

  module DoNotIncludeInMock
    def sample_method
    end
  end
  include DoNotIncludeInMock
  # self.primary_key = :lol
  # self.table_name = :posts
  # Returns microposts from the users being followed by the given user.
  def self.from_users_followed_by(user = nil)
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id",
      user_id: user.id)
  end

  def display_name
  end

  def post_id
    id
  end

  def i_take_block(&block)
  end
end
