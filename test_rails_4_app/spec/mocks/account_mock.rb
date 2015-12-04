require 'active_mocker/mock'

class AccountMock < ActiveMocker::Base
  created_with('2.0.0.beta1')

# _modules_constants.erb
#_class_methods.erb
  class << self
    def attributes
      @attributes ||= HashWithIndifferentAccess.new({"id"=>nil, "user_id"=>nil, "balance"=>nil}).merge(super)
    end

    def types
      @types ||= ActiveMocker::HashProcess.new({ id: Fixnum, user_id: Fixnum, balance: BigDecimal }, method(:build_type)).merge(super)
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
# _attributes.erb
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
# _associations.erb

# belongs_to
  def user
    read_association(:user) || write_association(:user, classes('User').try{ |k| k.find_by(id: user_id)})
  end
  def user=(val)
    write_association(:user, val)
    ActiveMocker::BelongsTo.new(val, child_self: self, foreign_key: :user_id).item
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


# _scopes.erb
  module Scopes
    include ActiveMocker::Base::Scopes

  end

  extend Scopes

  class ScopeRelation < ActiveMocker::Association
    include AccountMock::Scopes
  end

  def self.__new_relation__(collection)
    AccountMock::ScopeRelation.new(collection)
  end

  private_class_method :__new_relation__
end
