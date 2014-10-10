require 'active_mocker/mock'

class AccountMock < ActiveMocker::Mock::Base
  created_with('1.7rc1')

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

    def associations_by_class
      @associations_by_class ||= {"User"=>{:belongs_to=>[:user]}}.merge(super)
    end

    def mocked_class
      "Account"
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

    def table_name
      "accounts" || super
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
    read_association(:user)
  end

  def user=(val)
    write_association(:user, val)
    ActiveMocker::Mock::BelongsTo.new(val, child_self: self, foreign_key: :user_id, foreign_id: val.try(:id)).item
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