require 'active_mocker/mock_requires'
Object.send(:remove_const, "RelationshipMock") if ActiveMocker.class_exists?("RelationshipMock")

class RelationshipMock < ::ActiveHash::Base
  include ActiveMocker::ActiveHash::ARApi
  include ActiveMocker::MockInstanceMethods
  extend  ActiveMocker::MockClassMethods

  def initialize(attributes={}, &block)
    @attributes = HashWithIndifferentAccess.new({"id"=>nil, "follower_id"=>nil, "followed_id"=>nil, "created_at"=>nil, "updated_at"=>nil})
    @associations = HashWithIndifferentAccess.new({:follower=>nil, :followed=>nil})
    super(attributes, &block)
  end


  def self.column_names
    ["id", "follower_id", "followed_id", "created_at", "updated_at"]
  end

  def self.attribute_names
    @attribute_names = ["id", "follower_id", "followed_id", "created_at", "updated_at"]
  end

  ##################################
  #   Attributes getter/setters    #
  ##################################

  def id
    @attributes['id']
  end

  def id=(val)
    type = (types[:id] ||= Virtus::Attribute.build(Fixnum))
    @attributes['id'] = type.coerce(val)
  end

  def follower_id
    @attributes['follower_id']
  end

  def follower_id=(val)
    type = (types[:follower_id] ||= Virtus::Attribute.build(Fixnum))
    @attributes['follower_id'] = type.coerce(val)
  end

  def followed_id
    @attributes['followed_id']
  end

  def followed_id=(val)
    type = (types[:followed_id] ||= Virtus::Attribute.build(Fixnum))
    @attributes['followed_id'] = type.coerce(val)
  end

  def created_at
    @attributes['created_at']
  end

  def created_at=(val)
    type = (types[:created_at] ||= Virtus::Attribute.build(DateTime))
    @attributes['created_at'] = type.coerce(val)
  end

  def updated_at
    @attributes['updated_at']
  end

  def updated_at=(val)
    type = (types[:updated_at] ||= Virtus::Attribute.build(DateTime))
    @attributes['updated_at'] = type.coerce(val)
  end

  ##################################
  #   Association getter/setters   #
  ##################################

  def self.association_names
    @association_names = [:follower, :followed]
  end

  def follower
    associations['follower']
  end

  def follower=(val)
    associations['follower'] = val
    self.follower_id = val.id if respond_to?(:follower_id) && val.persisted?
  end

  def followed
    associations['followed']
  end

  def followed=(val)
    associations['followed'] = val
    self.followed_id = val.id if respond_to?(:followed_id) && val.persisted?
  end

  ##################################
  #  Model Methods getter/setters  #
  ##################################

  def self.model_instance_methods
    @model_instance_methods ||= {}
  end

  def self.model_class_methods
    @model_class_methods ||= {}
  end

  def self.clear_mock
    @model_class_methods, @model_instance_methods = nil, nil
    delete_all
  end

end
