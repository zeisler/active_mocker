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
    attributes['id'] = val
  end

  def follower_id
    attributes['follower_id']
  end

  def follower_id=(val)
    attributes['follower_id'] = val
  end

  def followed_id
    attributes['followed_id']
  end

  def followed_id=(val)
    attributes['followed_id'] = val
  end

  def created_at
    attributes['created_at']
  end

  def created_at=(val)
    attributes['created_at'] = val
  end

  def updated_at
    attributes['updated_at']
  end

  def updated_at=(val)
    attributes['updated_at'] = val
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
