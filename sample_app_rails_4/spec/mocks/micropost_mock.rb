require 'active_mocker/mock_requires'
Object.send(:remove_const, "MicropostMock") if ActiveMocker.class_exists?("MicropostMock")

class MicropostMock < ::ActiveHash::Base
  include ActiveMocker::ActiveHash::ARApi
  include ActiveMocker::MockInstanceMethods
  extend  ActiveMocker::MockClassMethods

  def self.column_names
    ["id", "content", "user_id", "created_at", "updated_at"]
  end

  def self.attribute_names
    @attribute_names = [:id, :content, :user_id, :created_at, :updated_at]
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

  def content
    attributes['content']
  end

  def content=(val)
    @types ||= {}
    @types[:content] = Virtus::Attribute.build(String) unless @types[:content]
    attributes['content'] = @types[:content].coerce(val)
  end

  def user_id
    attributes['user_id']
  end

  def user_id=(val)
    @types ||= {}
    @types[:user_id] = Virtus::Attribute.build(Fixnum) unless @types[:user_id]
    attributes['user_id'] = @types[:user_id].coerce(val)
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
    @association_names = [:user]
  end

  def user
    associations['user']
  end

  def user=(val)
    associations['user'] = val
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
    @model_class_methods[:from_users_followed_by] = :not_implemented
    @model_class_methods
  end

  def self.clear_mock
    @model_class_methods, @model_instance_methods = nil, nil
    delete_all
  end


  def self.from_users_followed_by(user)
    block =  model_class_methods[:from_users_followed_by]
    is_implemented(block, "::from_users_followed_by")
    instance_exec(*[user], &block)
  end


end
