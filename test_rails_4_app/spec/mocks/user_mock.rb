require 'active_mocker/mock'

class UserMock < ActiveMocker::Mock::Base
  created_with('1.8')

  class << self

    def attributes
      @attributes ||= HashWithIndifferentAccess.new({"id"=>nil, "name"=>nil, "email"=>"", "credits"=>nil, "created_at"=>nil, "updated_at"=>nil, "password_digest"=>nil, "remember_token"=>true, "admin"=>false}).merge(super)
    end

    def types
      @types ||= ActiveMocker::Mock::HashProcess.new({ id: Fixnum, name: String, email: String, credits: BigDecimal, created_at: DateTime, updated_at: DateTime, password_digest: String, remember_token: Axiom::Types::Boolean, admin: Axiom::Types::Boolean }, method(:build_type)).merge(super)
    end

    def mocked_class
      "User"
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

  def email
    read_attribute(:email)
  end

  def email=(val)
    write_attribute(:email, val)
  end

  module Scopes
    include ActiveMocker::Mock::Base::Scopes

    def find_by_name(name)
      ActiveMocker::LoadedMocks.find('User').send(:call_mock_method, 'find_by_name', name)
    end

    def by_name(name)
      ActiveMocker::LoadedMocks.find('User').send(:call_mock_method, 'by_name', name)
    end

  end

  extend Scopes

  class ScopeRelation < ActiveMocker::Mock::Association
    include UserMock::Scopes
  end

  private

  def self.new_relation(collection)
    UserMock::ScopeRelation.new(collection)
  end

end