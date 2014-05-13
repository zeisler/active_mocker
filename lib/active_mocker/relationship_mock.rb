require 'active_mocker/mock_instance_methods'
require 'active_mocker/mock_class_methods'
require 'active_hash'
require 'active_hash/ar_api'

class RelationshipsMock < ::ActiveHash::Base
  include ActiveMocker::ActiveHash::ARApi
  include ActiveMocker::MockInstanceMethods
  extend  ActiveMocker::MockClassMethods

  def self.column_names
    ["id", "follower_id", "followed_id", "created_at", "updated_at"]
  end

  def self.association_names
    @association_names = [:follower, :followed]
  end

  def self.attribute_names
    @attribute_names = [:id, :follower_id, :followed_id, :created_at, :updated_at]
  end


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




  def self.mock_instance_methods
    return @mock_instance_methods if @mock_instance_methods
    @mock_instance_methods = {}
    @mock_instance_methods
  end

  def self.mock_class_methods
    return @mock_class_methods if @mock_class_methods
    @mock_class_methods = {}
    @mock_class_methods
  end





end