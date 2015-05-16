class User < ActiveRecord::Base
  has_many :microposts, -> { order('created_at DESC') }
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name:  "Relationship",
                                   dependent:   :destroy
  has_many :followers, through: :reverse_relationships, source: :follower
  has_one :account
  scope :find_by_name, -> (name) { where(name: name) }
  scope :by_name, -> (name) { where(name: name) }
  scope :no_arg_scope, -> { where(name: 'name') }

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.digest(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def feed
    Micropost.from_users_followed_by(self)
  end

  def following?(other_user)
    relationships.find_by(followed_id: other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by(followed_id: other_user.id).destroy
  end

  def key_arg_reg(key:)

  end

  def key_arg_opt(key:nil)

  end

  private

  def create_remember_token
    self.remember_token = User.digest(User.new_remember_token)
  end
end
