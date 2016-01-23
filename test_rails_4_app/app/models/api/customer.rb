module Api
  class Customer < ActiveRecord::Base
    has_many :microposts, -> { order('created_at DESC') }

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

    def key_arg_opt(key: nil)

    end

    private

    def create_remember_token
      self.remember_token = User.digest(User.new_remember_token)
    end
  end
end
