require 'active_mocker/mock'
Object.send(:remove_const, "UserMock") if Object.const_defined?("UserMock")

class UserMock < ActiveMocker::Mock::Base

  class << self

    def attributes
      @attributes ||= HashWithIndifferentAccess.new({"id"=>nil, "name"=>nil, "age"=>nil, "admin"=>nil, "created_at"=>nil, "updated_at"=>nil})
    end

    def types
      @types ||= ActiveMocker::Mock::HashProcess.new({ id: Fixnum, name: String, age: Fixnum, admin: Axiom::Types::Boolean, created_at: DateTime, updated_at: DateTime }, method(:build_type))
    end

    def associations
      @associations ||= {:comments=>nil, :subscriptions=>nil}
    end

    def mocked_class
      'User'
    end

    private :mocked_class

    def attribute_names
      @attribute_names ||= ["id", "name", "age", "admin", "created_at", "updated_at"]
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

  def age
    read_attribute(:age)
  end

  def age=(val)
    write_attribute(:age, val)
  end

  def admin
    read_attribute(:admin)
  end

  def admin=(val)
    write_attribute(:admin, val)
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

  ##################################
  #         Associations           #
  ##################################


# has_many
  def comments
    @associations[:comments] ||= ActiveMocker::Mock::HasMany.new([],'user_id', @attributes['id'], classes('Comment'))
  end

  def comments=(val)
    @associations[:comments] ||= ActiveMocker::Mock::HasMany.new(val,'user_id', @attributes['id'], classes('Comment'))
  end

  def subscriptions
    @associations[:subscriptions] ||= ActiveMocker::Mock::HasMany.new([],'user_id', @attributes['id'], classes('Subscription'))
  end

  def subscriptions=(val)
    @associations[:subscriptions] ||= ActiveMocker::Mock::HasMany.new(val,'user_id', @attributes['id'], classes('Subscription'))
  end

  module Scopes

  end

  extend Scopes

  class ScopeRelation < ActiveMocker::Mock::Association
    include UserMock::Scopes
  end

  private

  def self.new_relation(collection)
    UserMock::ScopeRelation.new(collection)
  end

  public

  ##################################
  #        Model Methods           #
  ##################################


  private

  def self.reload
    load __FILE__
  end

end