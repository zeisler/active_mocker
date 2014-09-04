require 'active_mocker/mock'

class AccountMock < ActiveMocker::Mock::Base

  class << self

    def attributes
      @attributes ||= HashWithIndifferentAccess.new({"id"=>nil, "user_id"=>nil, "balance"=>nil}).merge(super)
    end

    def types
      @types ||= ActiveMocker::Mock::HashProcess.new({ id: Fixnum, user_id: Fixnum, balance: BigDecimal }, method(:build_type)).merge(super)
    end

    def associations
      @associations ||= {:user=>nil}.merge(super)
    end

    def mocked_class
      'Account'
    end

    private :mocked_class

    def attribute_names
      @attribute_names ||= ["id", "user_id", "balance"] | super
    end

    def primary_key
      "id"
    end

    def abstract_class?
      false
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

  def user_id
    read_attribute(:user_id)
  end

  def user_id=(val)
    write_attribute(:user_id, val)
    association = classes('User').try(:find_by, id: user_id)
    write_association(:user,association) unless association.nil?
  end

  def balance
    read_attribute(:balance)
  end

  def balance=(val)
    write_attribute(:balance, val)
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
      val.accounts << self if val.respond_to?(:accounts=)
      val.account = self if val.respond_to?(:account=)
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
    include ActiveMocker::Mock::Base::Scopes

  end

  extend Scopes

  class ScopeRelation < ActiveMocker::Mock::Association
    include AccountMock::Scopes
  end

  private

  def self.new_relation(collection)
    AccountMock::ScopeRelation.new(collection)
  end

  public

  ##################################
  #        Model Methods           #
  ##################################


end