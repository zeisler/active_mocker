# frozen_string_literal: true
require "active_mocker/mock"

class SubscriptionMock < ActiveMocker::Base
  created_with("2.0.0-alpha.0")
  # _modules_constants.erb

  # _class_methods.erb
  class << self
    def attributes
      @attributes ||= HashWithIndifferentAccess.new("id" => nil, "kind" => nil, "user_id" => nil, "active" => nil, "created_at" => nil, "updated_at" => nil).merge(super)
    end

    def types
      @types ||= ActiveMocker::HashProcess.new({ id: Fixnum, kind: String, user_id: Fixnum, active: Axiom::Types::Boolean, created_at: DateTime, updated_at: DateTime }, method(:build_type)).merge(super)
    end

    def associations
      @associations ||= { user: nil }.merge(super)
    end

    def associations_by_class
      @associations_by_class ||= { User: { belongs_to: [:user] } }.merge(super)
    end

    def mocked_class
      "Subscription"
    end

    private :mocked_class

    def attribute_names
      @attribute_names ||= %w(id kind user_id active created_at updated_at) | super
    end

    def primary_key
      "id"
    end

    def abstract_class?
      false
    end

    def table_name
      "subscriptions" || super
    end
  end
  # _attributes.erb
  def id
    read_attribute(:id)
  end

  def id=(val)
    write_attribute(:id, val)
  end

  def kind
    read_attribute(:kind)
  end

  def kind=(val)
    write_attribute(:kind, val)
  end

  def user_id
    read_attribute(:user_id)
  end

  def user_id=(val)
    write_attribute(:user_id, val)
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

  # _associations.erb

  # belongs_to
  def user
    read_association(:user) || write_association(:user, classes("User").try { |k| k.find_by(id: user_id) })
  end

  def user=(val)
    write_association(:user, val)
    ActiveMocker::BelongsTo.new(val, child_self: self, foreign_key: :user_id).item
  end

  def build_user(attributes = {}, &block)
    association = classes("User").try(:new, attributes, &block)
    write_association(:user, association) unless association.nil?
  end

  def create_user(attributes = {}, &block)
    association = classes("User").try(:create, attributes, &block)
    write_association(:user, association) unless association.nil?
  end
  alias create_user! create_user

  # _scopes.erb
  module Scopes
    include ActiveMocker::Base::Scopes
  end

  extend Scopes

  class ScopeRelation < ActiveMocker::Association
    include SubscriptionMock::Scopes
  end

  def self.__new_relation__(collection)
    SubscriptionMock::ScopeRelation.new(collection)
  end

  private_class_method :__new_relation__
end
