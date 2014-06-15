require 'active_mocker/active_mock'
Object.send(:remove_const, "RelationshipMock") if Object.const_defined?("RelationshipMock")

class RelationshipMock < ActiveMock::Base

  class << self

    def attributes
      @attributes ||= HashWithIndifferentAccess.new({"id"=>nil, "follower_id"=>nil, "followed_id"=>nil, "created_at"=>nil, "updated_at"=>nil})
    end

    def types
      @types ||= { id: build_type(Fixnum), follower_id: build_type(Fixnum), followed_id: build_type(Fixnum), created_at: build_type(DateTime), updated_at: build_type(DateTime) }
    end

    def associations
      @associations ||= {:follower=>nil, :followed=>nil}
    end

    def model_instance_methods
      @model_instance_methods ||= {}
    end

    def model_class_methods
      @model_class_methods ||= {}
    end

    def mocked_class
      'Relationship'
    end

    def column_names
      attribute_names
    end

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
    association = classes('User').try(:find, follower_id)
    write_association(:follower,association) unless association.nil?
  end

  def followed_id
    read_attribute(:followed_id)
  end

  def followed_id=(val)
    write_attribute(:followed_id, val)
    association = classes('User').try(:find, followed_id)
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
  end

  def build_follower(attributes={}, &block)
    association = classes('User').try(:new, attributes, &block)
    write_association(:follower, association) unless association.nil?
  end

  def create_follower(attributes={}, &block)
    association = classes('User').try(:create,attributes, &block)
    write_association(:follower, nil) unless association.nil?
  end
  alias_method :create_follower!, :create_follower

  def followed
    @associations[:followed]
  end

  def followed=(val)
    @associations[:followed] = val
    write_attribute(:followed_id, val.id) if val.respond_to?(:persisted?) && val.persisted?
  end

  def build_followed(attributes={}, &block)
    association = classes('User').try(:new, attributes, &block)
    write_association(:followed, association) unless association.nil?
  end

  def create_followed(attributes={}, &block)
    association = classes('User').try(:create,attributes, &block)
    write_association(:followed, nil) unless association.nil?
  end
  alias_method :create_followed!, :create_followed


  ##################################
  #  Model Methods getter/setters  #
  ##################################


  private

  def self.reload
    load __FILE__
  end

end