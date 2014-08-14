require 'active_mocker/mock'

class ChildModelMock < ActiveMocker::Mock::Base

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
      'ChildModel'
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
    include ChildModelMock::Scopes
  end

  private

  def self.new_relation(collection)
    ChildModelMock::ScopeRelation.new(collection)
  end

  public

  ##################################
  #        Model Methods           #
  ##################################


  def feed
    call_mock_method :feed
  end

  def following?(other_user)
    call_mock_method :following?, other_user
  end

  def follow!(other_user)
    call_mock_method :follow!, other_user
  end

  def unfollow!(other_user)
    call_mock_method :unfollow!, other_user
  end

  def self.get_named_scopes
    call_mock_method :get_named_scopes
  end

  private

  def self.reload
    load __FILE__
  end

end