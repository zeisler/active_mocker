require 'active_mocker/mock'

class UserMock < ActiveMocker::Base
  created_with('2.0.0.beta1')

# _modules_constants.erb
#_class_methods.erb
  class << self
    def attributes
      @attributes ||= HashWithIndifferentAccess.new({"id"=>nil, "name"=>nil, "email"=>"", "credits"=>nil, "created_at"=>nil, "updated_at"=>nil, "password_digest"=>nil, "remember_token"=>true, "admin"=>false}).merge(super)
    end

    def types
      @types ||= ActiveMocker::HashProcess.new({ id: Fixnum, name: String, email: String, credits: BigDecimal, created_at: DateTime, updated_at: DateTime, password_digest: String, remember_token: Axiom::Types::Boolean, admin: Axiom::Types::Boolean }, method(:build_type)).merge(super)
    end

    def associations
      @associations ||= {:account=>nil, :microposts=>nil, :relationships=>nil, :followed_users=>nil, :reverse_relationships=>nil, :followers=>nil}.merge(super)
    end

    def associations_by_class
      @associations_by_class ||= {"Account"=>{:has_one=>[:account]}, "Micropost"=>{:has_many=>[:microposts]}, "Relationship"=>{:has_many=>[:relationships, :reverse_relationships]}, "User"=>{:has_many=>[:followed_users, :followers]}}.merge(super)
    end

    def mocked_class
      "User"
    end

    private :mocked_class

    def attribute_names
      @attribute_names ||= ["id", "name", "email", "credits", "created_at", "updated_at", "password_digest", "remember_token", "admin"] | super
    end

    def primary_key
      "id"
    end

    def abstract_class?
      false
    end

    def table_name
      "users" || super
    end

  end
# _attributes.erb
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
# _associations.erb

# has_one
  def account
    read_association(:account)
  end

  def account=(val)
    write_association(:account, val)
    ActiveMocker::HasOne.new(val, child_self: self, foreign_key: 'user_id').item
  end

  def build_account(attributes={}, &block)
    write_association(:account, classes('Account').new(attributes, &block)) if classes('Account')
  end

  def create_account(attributes={}, &block)
    write_association(:account, classes('Account').new(attributes, &block)) if classes('Account')
  end
  alias_method :create_account!, :create_account

# has_many
  def microposts
    read_association(:microposts, -> { ActiveMocker::HasMany.new([],foreign_key: 'user_id', foreign_id: self.id, relation_class: classes('Micropost'), source: '') })
  end

  def microposts=(val)
    write_association(:microposts, ActiveMocker::HasMany.new(val, foreign_key: 'user_id', foreign_id: self.id, relation_class: classes('Micropost'), source: ''))
  end
  def relationships
    read_association(:relationships, -> { ActiveMocker::HasMany.new([],foreign_key: 'follower_id', foreign_id: self.id, relation_class: classes('Relationship'), source: '') })
  end

  def relationships=(val)
    write_association(:relationships, ActiveMocker::HasMany.new(val, foreign_key: 'follower_id', foreign_id: self.id, relation_class: classes('Relationship'), source: ''))
  end
  def followed_users
    read_association(:followed_users, -> { ActiveMocker::HasMany.new([],foreign_key: 'followed_id', foreign_id: self.id, relation_class: classes('User'), source: 'followed') })
  end

  def followed_users=(val)
    write_association(:followed_users, ActiveMocker::HasMany.new(val, foreign_key: 'followed_id', foreign_id: self.id, relation_class: classes('User'), source: 'followed'))
  end
  def reverse_relationships
    read_association(:reverse_relationships, -> { ActiveMocker::HasMany.new([],foreign_key: 'followed_id', foreign_id: self.id, relation_class: classes('Relationship'), source: '') })
  end

  def reverse_relationships=(val)
    write_association(:reverse_relationships, ActiveMocker::HasMany.new(val, foreign_key: 'followed_id', foreign_id: self.id, relation_class: classes('Relationship'), source: ''))
  end
  def followers
    read_association(:followers, -> { ActiveMocker::HasMany.new([],foreign_key: 'follower_id', foreign_id: self.id, relation_class: classes('User'), source: 'follower') })
  end

  def followers=(val)
    write_association(:followers, ActiveMocker::HasMany.new(val, foreign_key: 'follower_id', foreign_id: self.id, relation_class: classes('User'), source: 'follower'))
  end

# _scopes.erb
  module Scopes
    include ActiveMocker::Base::Scopes

    def find_by_name(name)
      ActiveMocker::LoadedMocks.find('User').send(:call_mock_method, method: 'find_by_name', caller: Kernel.caller, arguments: [name])
    end

    def by_name(name)
      ActiveMocker::LoadedMocks.find('User').send(:call_mock_method, method: 'by_name', caller: Kernel.caller, arguments: [name])
    end

    def no_arg_scope
      ActiveMocker::LoadedMocks.find('User').send(:call_mock_method, method: 'no_arg_scope', caller: Kernel.caller, arguments: [])
    end

  end

  extend Scopes

  class ScopeRelation < ActiveMocker::Association
    include UserMock::Scopes
  end

  def self.__new_relation__(collection)
    UserMock::ScopeRelation.new(collection)
  end

  private_class_method :__new_relation__
  def feed
    call_mock_method(method: __method__, caller: Kernel.caller, arguments: [])
  end
  def following?(other_user)
    call_mock_method(method: __method__, caller: Kernel.caller, arguments: [other_user])
  end
  def follow!(other_user)
    call_mock_method(method: __method__, caller: Kernel.caller, arguments: [other_user])
  end
  def unfollow!(other_user)
    call_mock_method(method: __method__, caller: Kernel.caller, arguments: [other_user])
  end
  def key_arg_reg(key:)
    call_mock_method(method: __method__, caller: Kernel.caller, arguments: [key: key])
  end
  def key_arg_opt(key: nil)
    call_mock_method(method: __method__, caller: Kernel.caller, arguments: [key: key])
  end
  def self.new_remember_token
    call_mock_method(method: __method__, caller: Kernel.caller, arguments: [])
  end
  def self.digest(token)
    call_mock_method(method: __method__, caller: Kernel.caller, arguments: [token])
  end
end
