class Micropost < ActiveRecord::Base
  belongs_to :user
  default_scope -> { order('created_at DESC') }
  MAGIC_ID = 90
  # self.primary_key = :lol
  # self.table_name = :posts
  # Returns microposts from the users being followed by the given user.
  def self.from_users_followed_by(user=nil)
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id",
          user_id: user.id)
  end
end
