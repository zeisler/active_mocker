require 'active_mocker/active_mock'
Object.send(:remove_const, "UserMock") if Object.const_defined?("UserMock")

class UserMock < ActiveMock::Base

  class << self

    def attributes
      @attributes ||= HashWithIndifferentAccess.new({"id"=>nil, "name"=>nil, "email"=>"", "credits"=>nil, "created_at"=>nil, "updated_at"=>nil, "password_digest"=>nil, "remember_token"=>true, "admin"=>false})
    end

    def types
      @types ||= { id: build_type(Fixnum), name: build_type(String), email: build_type(String), credits: build_type(BigDecimal), created_at: build_type(DateTime), updated_at: build_type(DateTime), password_digest: build_type(String), remember_token: build_type(Axiom::Types::Boolean), admin: build_type(Axiom::Types::Boolean) }
    end

    def associations
      @associations ||= {:microposts=>nil, :relationships=>nil, :followed_users=>nil, :reverse_relationships=>nil, :followers=>nil}
    end

    def model_instance_methods
      @model_instance_methods ||= {"feed"=>:not_implemented, "following?"=>:not_implemented, "follow!"=>:not_implemented, "unfollow!"=>:not_implemented}
    end

    def model_class_methods
      @model_class_methods ||= {"new_remember_token"=>:not_implemented, "digest"=>:not_implemented}
    end

    def mocked_class
      'User'
    end

    def column_names
      attribute_names
    end

    def attribute_names
      @attribute_names ||= ["id", "name", "email", "credits", "created_at", "updated_at", "password_digest", "remember_token", "admin"]
    end

    def primary_key
      "id"
    end

  end

  ##################################
  #   Attributes getter/setters    #
  ##################################

  def id
    read_attribute(:id)
  end

  def id=(val)
    write_attribute(:id, val)
  end

  def name
    read_attribute(:name)
  end

  def name=(val)
    write_attribute(:name, val)
  end

  def email
    read_attribute(:email)
  end

  def email=(val)
    write_attribute(:email, val)
  end

  def credits
    read_attribute(:credits)
  end

  def credits=(val)
    write_attribute(:credits, val)
  end

  def created_at
    read_attribute(:created_at)
  end

  def created_at=(val)
    write_attribute(:created_at, val)
  end

  def updated_at
    read_attribute(:updated_at)
  end

  def updated_at=(val)
    write_attribute(:updated_at, val)
  end

  def password_digest
    read_attribute(:password_digest)
  end

  def password_digest=(val)
    write_attribute(:password_digest, val)
  end

  def remember_token
    read_attribute(:remember_token)
  end

  def remember_token=(val)
    write_attribute(:remember_token, val)
  end

  def admin
    read_attribute(:admin)
  end

  def admin=(val)
    write_attribute(:admin, val)
  end

  ##################################
  #         Associations           #
  ##################################


# has_many
  def microposts
    @associations[:microposts] ||= ActiveMock::HasMany.new([],'user_id', @attributes['id'], 'MicropostMock')
  end

  def microposts=(val)
    @associations[:microposts] ||= ActiveMock::HasMany.new(val,'user_id', @attributes['id'], 'MicropostMock')
  end

  def relationships
    @associations[:relationships] ||= ActiveMock::HasMany.new([],'follower_id', @attributes['id'], 'RelationshipMock')
  end

  def relationships=(val)
    @associations[:relationships] ||= ActiveMock::HasMany.new(val,'follower_id', @attributes['id'], 'RelationshipMock')
  end

  def followed_users
    @associations[:followed_users] ||= ActiveMock::HasMany.new([],'user_id', @attributes['id'], 'FollowedUserMock')
  end

  def followed_users=(val)
    @associations[:followed_users] ||= ActiveMock::HasMany.new(val,'user_id', @attributes['id'], 'FollowedUserMock')
  end

  def reverse_relationships
    @associations[:reverse_relationships] ||= ActiveMock::HasMany.new([],'followed_id', @attributes['id'], 'RelationshipMock')
  end

  def reverse_relationships=(val)
    @associations[:reverse_relationships] ||= ActiveMock::HasMany.new(val,'followed_id', @attributes['id'], 'RelationshipMock')
  end

  def followers
    @associations[:followers] ||= ActiveMock::HasMany.new([],'user_id', @attributes['id'], 'FollowerMock')
  end

  def followers=(val)
    @associations[:followers] ||= ActiveMock::HasMany.new(val,'user_id', @attributes['id'], 'FollowerMock')
  end

  ##################################
  #  Model Methods getter/setters  #
  ##################################


  def feed()
    block =  model_instance_methods['feed']
    self.class.is_implemented(block, '#feed')
    instance_exec(*[], &block)
  end

  def following?(other_user)
    block =  model_instance_methods['following?']
    self.class.is_implemented(block, '#following?')
    instance_exec(*[other_user], &block)
  end

  def follow!(other_user)
    block =  model_instance_methods['follow!']
    self.class.is_implemented(block, '#follow!')
    instance_exec(*[other_user], &block)
  end

  def unfollow!(other_user)
    block =  model_instance_methods['unfollow!']
    self.class.is_implemented(block, '#unfollow!')
    instance_exec(*[other_user], &block)
  end

  def self.new_remember_token()
    block =  model_class_methods['new_remember_token']
    is_implemented(block, '::new_remember_token')
    instance_exec(*[], &block)
  end

  def self.digest(token)
    block =  model_class_methods['digest']
    is_implemented(block, '::digest')
    instance_exec(*[token], &block)
  end

  private

  def self.reload
    load __FILE__
  end

end