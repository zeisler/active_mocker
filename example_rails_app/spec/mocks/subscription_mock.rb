require 'active_mocker/mock'
Object.send(:remove_const, "SubscriptionMock") if Object.const_defined?("SubscriptionMock")

class SubscriptionMock < ActiveMocker::Mock::Base

  class << self

    def attributes
      @attributes ||= HashWithIndifferentAccess.new({"id"=>nil, "type"=>nil, "user_id"=>nil, "active"=>nil, "created_at"=>nil, "updated_at"=>nil})
    end

    def types
      @types ||= ActiveMocker::Mock::HashProcess.new({ id: Fixnum, type: String, user_id: Fixnum, active: Axiom::Types::Boolean, created_at: DateTime, updated_at: DateTime }, method(:build_type))
    end

    def associations
      @associations ||= {:user=>nil}
    end

    def mocked_class
      'Subscription'
    end

    private :mocked_class

    def attribute_names
      @attribute_names ||= ["id", "type", "user_id", "active", "created_at", "updated_at"]
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

  def type
    read_attribute(:type)
  end

  def type=(val)
    write_attribute(:type, val)
  end

  def user_id
    read_attribute(:user_id)
  end

  def user_id=(val)
    write_attribute(:user_id, val)
    association = classes('User').try(:find_by, id: user_id)
    write_association(:user,association) unless association.nil?
  end

  def active
    read_attribute(:active)
  end

  def active=(val)
    write_attribute(:active, val)
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

# belongs_to
  def user
    @associations[:user]
  end

  def user=(val)
    @associations[:user] = val
    write_attribute(:user_id, val.id) if val.respond_to?(:persisted?) && val.persisted?
    if ActiveMocker::Mock.config.experimental
      val.subscriptions << self if val.respond_to?(:subscriptions=)
      val.subscription = self if val.respond_to?(:subscription=)
    end
    val
  end

  def build_user(attributes={}, &block)
    association = classes('User').try(:new, attributes, &block)
    write_association(:user, association) unless association.nil?
  end

  def create_user(attributes={}, &block)
    association = classes('User').try(:create,attributes, &block)
    write_association(:user, association) unless association.nil?
  end
  alias_method :create_user!, :create_user


  module Scopes

  end

  extend Scopes

  class ScopeRelation < ActiveMocker::Mock::Association
    include SubscriptionMock::Scopes
  end

  private

  def self.new_relation(collection)
    SubscriptionMock::ScopeRelation.new(collection)
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