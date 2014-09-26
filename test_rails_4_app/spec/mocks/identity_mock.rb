require 'active_mocker/mock'

class IdentityMock < ActiveMocker::Mock::Base

  class << self

    def attributes
      @attributes ||= HashWithIndifferentAccess.new({}).merge(super)
    end

    def types
      @types ||= ActiveMocker::Mock::HashProcess.new({  }, method(:build_type)).merge(super)
    end

    def associations
      @associations ||= {}.merge(super)
    end

    def associations_by_class
      @associations_by_class ||= {}.merge(super)
    end

    def mocked_class
      'Identity'
    end

    private :mocked_class

    def attribute_names
      @attribute_names ||= [] | super
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

  ##################################
  #         Associations           #
  ##################################



  module Scopes
    include ActiveMocker::Mock::Base::Scopes

  end

  extend Scopes

  class ScopeRelation < ActiveMocker::Mock::Association
    include IdentityMock::Scopes
  end

  private

  def self.new_relation(collection)
    IdentityMock::ScopeRelation.new(collection)
  end

  public

  ##################################
  #        Model Methods           #
  ##################################


end