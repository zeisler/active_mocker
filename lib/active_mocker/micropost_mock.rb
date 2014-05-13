require 'active_mocker/mock_instance_methods'
require 'active_mocker/mock_class_methods'
require 'active_hash'
require 'active_hash/ar_api'

class MicropostsMock < ::ActiveHash::Base
  include ActiveMocker::ActiveHash::ARApi
  include ActiveMocker::MockInstanceMethods
  extend  ActiveMocker::MockClassMethods

  def self.column_names
    ["id", "content", "user_id", "created_at", "updated_at"]
  end

  def self.association_names
    @association_names = [:user]
  end

  def self.attribute_names
    @attribute_names = [:id, :content, :user_id, :created_at, :updated_at]
  end


  def id
    attributes['id']
  end

  def id=(val)
    attributes['id'] = val
  end

  def content
    attributes['content']
  end

  def content=(val)
    attributes['content'] = val
  end

  def user_id
    attributes['user_id']
  end

  def user_id=(val)
    attributes['user_id'] = val
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



  def user
    associations['user']
  end

  def user=(val)
    associations['user'] = val
  end




  def self.mock_instance_methods
    return @mock_instance_methods if @mock_instance_methods
    @mock_instance_methods = {}
    @mock_instance_methods
  end

  def self.mock_class_methods
    return @mock_class_methods if @mock_class_methods
    @mock_class_methods = {}
    @mock_class_methods[:from_users_followed_by] = :not_implemented
  
    @mock_class_methods
  end




  def self.from_users_followed_by(user)
    block =  mock_class_methods[:from_users_followed_by]
    is_implemented(block, "::from_users_followed_by")
    instance_exec(*[user], &block)
  end


end