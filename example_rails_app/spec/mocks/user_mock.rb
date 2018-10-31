# frozen_string_literal: true

require "active_mocker/mock"

class UserMock < ActiveMocker::Base
  created_with("2.0.0-alpha.0")
  # _modules_constants.erb

  # _class_methods.erb
  class << self
    def attributes
      @attributes ||= HashWithIndifferentAccess.new("id" => nil, "name" => nil, "age" => nil, "admin" => nil, "created_at" => nil, "updated_at" => nil).merge(super)
    end

    def types
      @types ||= ActiveMocker::HashProcess.new({ id: Integer, name: String, age: Integer, admin: Axiom::Types::Boolean, created_at: DateTime, updated_at: DateTime }, method(:build_type)).merge(super)
    end

    def associations
      @associations ||= { comments: nil, subscriptions: nil }.merge(super)
    end

    def associations_by_class
      @associations_by_class ||= { Comment: { has_many: [:comments] }, Subscription: { has_many: [:subscriptions] } }.merge(super)
    end

    def mocked_class
      "User"
    end

    private :mocked_class

    def attribute_names
      @attribute_names ||= %w[id name age admin created_at updated_at] | super
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

  # _associations.erb

  # has_many
  def comments
    read_association(:comments, -> { ActiveMocker::HasMany.new([], foreign_key: "user_id", foreign_id: id, relation_class: classes("Comment"), source: "") })
  end

  def comments=(val)
    write_association(:comments, ActiveMocker::HasMany.new(val, foreign_key: "user_id", foreign_id: id, relation_class: classes("Comment"), source: ""))
  end

  def subscriptions
    read_association(:subscriptions, -> { ActiveMocker::HasMany.new([], foreign_key: "user_id", foreign_id: id, relation_class: classes("Subscription"), source: "") })
  end

  def subscriptions=(val)
    write_association(:subscriptions, ActiveMocker::HasMany.new(val, foreign_key: "user_id", foreign_id: id, relation_class: classes("Subscription"), source: ""))
  end

  # _scopes.erb
  module Scopes
    include ActiveMocker::Base::Scopes
  end

  extend Scopes

  class ScopeRelation < ActiveMocker::Association
    include UserMock::Scopes
  end

  def self.__new_relation__(collection)
    UserMock::ScopeRelation.new(collection)
  end

  private_class_method :__new_relation__
end
