require 'active_mocker/mock'

class HasNoTableMock < ActiveMocker::Mock::Base

  class << self

    def attributes
      @attributes ||= HashWithIndifferentAccess.new({})
    end

    def types
      @types ||= ActiveMocker::Mock::HashProcess.new({  }, method(:build_type))
    end

    def associations
      @associations ||= {}
    end

    def mocked_class
      'HasNoTable'
    end

    private :mocked_class

    def attribute_names
      @attribute_names ||= []
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

  ##################################
  #         Associations           #
  ##################################



  module Scopes

  end

  extend Scopes

  class ScopeRelation < ActiveMocker::Mock::Association
    include HasNoTableMock::Scopes
  end

  private

  def self.new_relation(collection)
    HasNoTableMock::ScopeRelation.new(collection)
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