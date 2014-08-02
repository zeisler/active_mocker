require 'active_mocker/mock'

class RelationshipMock < ActiveMocker::Mock::Base

  class << self

    def attributes
      @attributes ||= HashWithIndifferentAccess.new({"id"=>nil, "follower_id"=>nil, "followed_id"=>nil, "created_at"=>nil, "updated_at"=>nil})
    end

    def types
      @types ||= ActiveMocker::Mock::HashProcess.new({ id: Fixnum, follower_id: Fixnum, followed_id: Fixnum, created_at: DateTime, updated_at: DateTime }, method(:build_type))
    end

    def associations
      @associations ||= {:follower=>nil, :followed=>nil}
    end

    def mocked_class
      'Relationship'
    end

    private :mocked_class

    def attribute_names
      @attribute_names ||= ["id", "follower_id", "followed_id", "created_at", "updated_at"]
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

  def follower_id
    read_attribute(:follower_id)
  end

  def follower_id=(val)
    write_attribute(:follower_id, val)
    association = classes('User').try(:find_by, id: follower_id)
    write_association(:follower,association) unless association.nil?
  end

  def followed_id
    read_attribute(:followed_id)
  end

  def followed_id=(val)
    write_attribute(:followed_id, val)
    association = classes('User').try(:find_by, id: followed_id)
    write_association(:followed,association) unless association.nil?
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
    @associations[:follower]
  end

  def follower=(val)
    @associations[:follower] = val
    write_attribute(:follower_id, val.id) if val.respond_to?(:persisted?) && val.persisted?
    if ActiveMocker::Mock.config.experimental
      val.relationships << self if val.respond_to?(:relationships=)
      val.relationship = self if val.respond_to?(:relationship=)
    end
    val
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
    @associations[:followed]
  end

  def followed=(val)
    @associations[:followed] = val
    write_attribute(:followed_id, val.id) if val.respond_to?(:persisted?) && val.persisted?
    if ActiveMocker::Mock.config.experimental
      val.relationships << self if val.respond_to?(:relationships=)
      val.relationship = self if val.respond_to?(:relationship=)
    end
    val
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


  private

  def self.reload
    load __FILE__
  end

end