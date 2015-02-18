require 'active_mocker/mock'

class RelationshipMock < ActiveMocker::Mock::Base
  created_with('1.8.1')

  class << self

    def attributes
      @attributes ||= HashWithIndifferentAccess.new({"id"=>nil, "follower_id"=>nil, "followed_id"=>nil, "created_at"=>nil, "updated_at"=>nil}).merge(super)
    end

    def types
      @types ||= ActiveMocker::Mock::HashProcess.new({ id: Fixnum, follower_id: Fixnum, followed_id: Fixnum, created_at: DateTime, updated_at: DateTime }, method(:build_type)).merge(super)
    end

    def associations
      @associations ||= {:follower=>nil, :followed=>nil}.merge(super)
    end

    def associations_by_class
      @associations_by_class ||= {"User"=>{:belongs_to=>[:follower, :followed]}}.merge(super)
    end

    def mocked_class
      "Relationship"
    end

    private :mocked_class

    def attribute_names
      @attribute_names ||= ["id", "follower_id", "followed_id", "created_at", "updated_at"] | super
    end

    def primary_key
      "id"
    end

    def abstract_class?
      false
    end

    def table_name
      "relationships" || super
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

  def follower_id
    read_attribute(:follower_id)
  end

  def follower_id=(val)
    write_attribute(:follower_id, val)
  end

  def followed_id
    read_attribute(:followed_id)
  end

  def followed_id=(val)
    write_attribute(:followed_id, val)
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

  ##################################
  #         Associations           #
  ##################################

# belongs_to
  def follower
    read_association(:follower) || write_association(:follower, classes('User').try{ |k| k.find_by(id: follower_id)})
  end

  def follower=(val)
    write_association(:follower, val)
    ActiveMocker::Mock::BelongsTo.new(val, child_self: self, foreign_key: :follower_id).item
  end

  def build_follower(attributes={}, &block)
    association = classes('User').try(:new, attributes, &block)
    write_association(:follower, association) unless association.nil?
  end

  def create_follower(attributes={}, &block)
    association = classes('User').try(:create,attributes, &block)
    write_association(:follower, association) unless association.nil?
  end
  alias_method :create_follower!, :create_follower

  def followed
    read_association(:followed) || write_association(:followed, classes('User').try{ |k| k.find_by(id: followed_id)})
  end

  def followed=(val)
    write_association(:followed, val)
    ActiveMocker::Mock::BelongsTo.new(val, child_self: self, foreign_key: :followed_id).item
  end

  def build_followed(attributes={}, &block)
    association = classes('User').try(:new, attributes, &block)
    write_association(:followed, association) unless association.nil?
  end

  def create_followed(attributes={}, &block)
    association = classes('User').try(:create,attributes, &block)
    write_association(:followed, association) unless association.nil?
  end
  alias_method :create_followed!, :create_followed


  module Scopes
    include ActiveMocker::Mock::Base::Scopes

  end

  extend Scopes

  class ScopeRelation < ActiveMocker::Mock::Association
    include RelationshipMock::Scopes
  end

  private

  def self.new_relation(collection)
    RelationshipMock::ScopeRelation.new(collection)
  end

  public

  ##################################
  #        Model Methods           #
  ##################################


end