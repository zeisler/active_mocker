require 'active_mocker/mock'

class IdentityMock < ActiveMocker::Base
  created_with('2.0.0.rc1')

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
      @associations ||= {}.merge(super)
    end

    def associations_by_class
      @associations_by_class ||= {}.merge(super)
    end

    def mocked_class
      "Identity"
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
      "identities" || super
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



# _scopes.erb
  module Scopes
    include ActiveMocker::Base::Scopes

  end

  extend Scopes

  class ScopeRelation < ActiveMocker::Association
    include IdentityMock::Scopes
  end

  def self.__new_relation__(collection)
    IdentityMock::ScopeRelation.new(collection)
  end

  private_class_method :__new_relation__
end
