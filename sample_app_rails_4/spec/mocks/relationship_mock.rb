require 'active_mocker/mock_requires'
Object.send(:remove_const, "RelationshipMock") if ActiveMocker.class_exists?("RelationshipMock")

class RelationshipMock < ::ActiveHash::Base
  include ActiveMocker::ActiveHash::ARApi
  include ActiveMocker::MockInstanceMethods
  extend  ActiveMocker::MockClassMethods

  def self.column_names
    ["id", "follower_id", "followed_id", "created_at", "updated_at"]
  end

  def self.attribute_names
    @attribute_names = [:id, :follower_id, :followed_id, :created_at, :updated_at]
  end

  ##################################
  #   Attributes getter/setters    #
  ##################################

  def id
    attributes['id']
  end

  def id=(val)
    @types ||= {}
    @types[:id] = Virtus::Attribute.build(Fixnum) unless @types[:id]
    attributes['id'] = @types[:id].coerce(val)
  end

  def follower_id
    attributes['follower_id']
  end

  def follower_id=(val)
    @types ||= {}
    @types[:follower_id] = Virtus::Attribute.build(Fixnum) unless @types[:follower_id]
    attributes['follower_id'] = @types[:follower_id].coerce(val)
  end

  def followed_id
    attributes['followed_id']
  end

  def followed_id=(val)
    @types ||= {}
    @types[:followed_id] = Virtus::Attribute.build(Fixnum) unless @types[:followed_id]
    attributes['followed_id'] = @types[:followed_id].coerce(val)
  end

  def created_at
    attributes['created_at']
  end

  def created_at=(val)
    @types ||= {}
    @types[:created_at] = Virtus::Attribute.build(DateTime) unless @types[:created_at]
    attributes['created_at'] = @types[:created_at].coerce(val)
  end

  def updated_at
    attributes['updated_at']
  end

  def updated_at=(val)
    @types ||= {}
    @types[:updated_at] = Virtus::Attribute.build(DateTime) unless @types[:updated_at]
    attributes['updated_at'] = @types[:updated_at].coerce(val)
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
  end

  def followed
    associations['followed']
  end

  def followed=(val)
    associations['followed'] = val
  end


  ##################################
  #  Model Methods getter/setters  #
  ##################################

  def self.model_instance_methods
    return @model_instance_methods if @model_instance_methods
    @model_instance_methods = {}
    @model_instance_methods
  end

  def self.model_class_methods
    return @model_class_methods if @model_class_methods
    @model_class_methods = {}
    @model_class_methods
  end

  def self.clear_mock
    @model_class_methods, @model_instance_methods = nil, nil
    delete_all
  end



end
