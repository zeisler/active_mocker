require 'active_mocker/mock'

class UserMock < ActiveMocker::Mock::Base
  created_with('1.8.1')

  class << self

    def attributes
      @attributes ||= HashWithIndifferentAccess.new({"id"=>nil, "name"=>nil, "age"=>nil, "admin"=>nil, "created_at"=>nil, "updated_at"=>nil}).merge(super)
    end

    def types
      @types ||= ActiveMocker::Mock::HashProcess.new({ id: Fixnum, name: String, age: Fixnum, admin: Axiom::Types::Boolean, created_at: DateTime, updated_at: DateTime }, method(:build_type)).merge(super)
    end

    def associations
      @associations ||= {:comments=>nil, :subscriptions=>nil}.merge(super)
    end

    def associations_by_class
      @associations_by_class ||= {"Comment"=>{:has_many=>[:comments]}, "Subscription"=>{:has_many=>[:subscriptions]}}.merge(super)
    end

    def mocked_class
      "User"
    end

    private :mocked_class

    def attribute_names
      @attribute_names ||= ["id", "name", "age", "admin", "created_at", "updated_at"] | super
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
    read_association(:comments, -> { ActiveMocker::Mock::HasMany.new([],foreign_key: 'user_id', foreign_id: self.id, relation_class: classes('Comment'), source: '') })
  end

  def comments=(val)
    write_association(:comments, ActiveMocker::Mock::HasMany.new(val, foreign_key: 'user_id', foreign_id: self.id, relation_class: classes('Comment'), source: ''))
  end

  def subscriptions
    read_association(:subscriptions, -> { ActiveMocker::Mock::HasMany.new([],foreign_key: 'user_id', foreign_id: self.id, relation_class: classes('Subscription'), source: '') })
  end

  def subscriptions=(val)
    write_association(:subscriptions, ActiveMocker::Mock::HasMany.new(val, foreign_key: 'user_id', foreign_id: self.id, relation_class: classes('Subscription'), source: ''))
  end

  module Scopes
    include ActiveMocker::Mock::Base::Scopes

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


end