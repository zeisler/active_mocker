require 'active_mocker/mock'

class AccountMock < ActiveMocker::Mock::Base

  class << self

    def attributes
      @attributes ||= HashWithIndifferentAccess.new({"id"=>nil, "user_id"=>nil, "balance"=>nil})
    end

    def types
      @types ||= ActiveMocker::Mock::HashProcess.new({ id: Fixnum, user_id: Fixnum, balance: BigDecimal }, method(:build_type))
    end

    def associations
      @associations ||= {:user=>nil}
    end

    def mocked_class
      'Account'
    end

    private :mocked_class

    def attribute_names
      @attribute_names ||= ["id", "user_id", "balance"]
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

  def user_id
    read_attribute(:user_id)
  end

  def user_id=(val)
    write_attribute(:user_id, val)
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

# has_one
  def user
    read_association('user')
  end

  def user=(val)
    @associations['user'] = val
    if ActiveMocker::Mock.config.experimental
      user.accounts <<  self if val.respond_to?(:accounts=)
      user.send(:write_association, :account,  self) if val.respond_to?(:account=)
    end
    val
  end

  def build_user(attributes={}, &block)
    write_association(:user, classes('User').new(attributes, &block)) if classes('User')
  end

  def create_user(attributes={}, &block)
    write_association(:user, classes('User').new(attributes, &block)) if classes('User')
  end
  alias_method :create_user!, :create_user


  module Scopes

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


  private

  def self.reload
    load __FILE__
  end

end