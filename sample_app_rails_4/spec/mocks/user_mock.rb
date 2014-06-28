require 'active_mocker/mock'
Object.send(:remove_const, "UserMock") if Object.const_defined?("UserMock")

class UserMock < ActiveMocker::Mock::Base

  class << self

    def attributes
      @attributes ||= HashWithIndifferentAccess.new({"id"=>nil, "name"=>nil, "email"=>"", "credits"=>nil, "created_at"=>nil, "updated_at"=>nil, "password_digest"=>nil, "remember_token"=>true, "admin"=>false})
    end

    def types
      @types ||= ActiveMocker::Mock::HashProcess.new({ id: Fixnum, name: String, email: String, credits: BigDecimal, created_at: DateTime, updated_at: DateTime, password_digest: String, remember_token: Axiom::Types::Boolean, admin: Axiom::Types::Boolean }, method(:build_type))
    end

    def associations
      @associations ||= {:microposts=>nil, :relationships=>nil, :followed_users=>nil, :reverse_relationships=>nil, :followers=>nil}
    end

    def mocked_class
      'User'
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
    @associations[:microposts] ||= ActiveMocker::Mock::HasMany.new([],'user_id', @attributes['id'], classes('Micropost'))
  end

  def microposts=(val)
    @associations[:microposts] ||= ActiveMocker::Mock::HasMany.new(val,'user_id', @attributes['id'], classes('Micropost'))
  end

  def relationships
    @associations[:relationships] ||= ActiveMocker::Mock::HasMany.new([],'follower_id', @attributes['id'], classes('Relationship'))
  end

  def relationships=(val)
    @associations[:relationships] ||= ActiveMocker::Mock::HasMany.new(val,'follower_id', @attributes['id'], classes('Relationship'))
  end

  def followed_users
    @associations[:followed_users] ||= ActiveMocker::Mock::HasMany.new([],'user_id', @attributes['id'], classes('FollowedUser'))
  end

  def followed_users=(val)
    @associations[:followed_users] ||= ActiveMocker::Mock::HasMany.new(val,'user_id', @attributes['id'], classes('FollowedUser'))
  end

  def reverse_relationships
    @associations[:reverse_relationships] ||= ActiveMocker::Mock::HasMany.new([],'followed_id', @attributes['id'], classes('Relationship'))
  end

  def reverse_relationships=(val)
    @associations[:reverse_relationships] ||= ActiveMocker::Mock::HasMany.new(val,'followed_id', @attributes['id'], classes('Relationship'))
  end

  def followers
    @associations[:followers] ||= ActiveMocker::Mock::HasMany.new([],'user_id', @attributes['id'], classes('Follower'))
  end

  def followers=(val)
    @associations[:followers] ||= ActiveMocker::Mock::HasMany.new(val,'user_id', @attributes['id'], classes('Follower'))
  end

  module Scopes

    def find_by_name(name)
      block = ActiveMocker::LoadedMocks.find('User').send(:get_mock_class_method, 'find_by_name')
      block.call(*[name])
    end

    def by_name(name)
      block = ActiveMocker::LoadedMocks.find('User').send(:get_mock_class_method, 'by_name')
      block.call(*[name])
    end

    class Relation < ActiveMocker::Mock::Association
      include Scopes
    end

  end

  extend Scopes

  ##################################
  #  Model Methods getter/setters  #
  ##################################


  def feed()
    call_mock_method :feed
  end

  def following?(other_user)
    call_mock_method :following?, other_user
  end

  def follow!(other_user)
    call_mock_method :follow!, other_user
  end

  def unfollow!(other_user)
    call_mock_method :unfollow!, other_user
  end

  def self.new_remember_token
    call_mock_method :new_remember_token
  end

  def self.digest(token)
    call_mock_method :digest, token
  end

  private

  def self.reload
    load __FILE__
  end

end