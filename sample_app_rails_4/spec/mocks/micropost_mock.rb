require 'active_mocker/active_mock'
Object.send(:remove_const, "MicropostMock") if Object.const_defined?("MicropostMock")

class MicropostMock < ActiveMock::Base

  MAGIC_ID_NUMBER = 90

  MAGIC_ID_STRING = "F-1"

  class << self

    def attributes
      @attributes ||= HashWithIndifferentAccess.new({"id"=>nil, "content"=>nil, "user_id"=>nil, "up_votes"=>nil, "created_at"=>nil, "updated_at"=>nil})
    end

    def types
      @types ||= { id: build_type(Fixnum), content: build_type(String), user_id: build_type(Fixnum), up_votes: build_type(Fixnum), created_at: build_type(DateTime), updated_at: build_type(DateTime) }
    end

    def associations
      @associations ||= {:user=>nil}
    end

    def model_instance_methods
      @model_instance_methods ||= {"display_name"=>:not_implemented}
    end

    def model_class_methods
      @model_class_methods ||= {"from_users_followed_by"=>:not_implemented}
    end

    def mocked_class
      'Micropost'
    end

    def column_names
      attribute_names
    end

    def attribute_names
      @attribute_names ||= ["id", "content", "user_id", "up_votes", "created_at", "updated_at"]
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

  def content
    read_attribute(:content)
  end

  def content=(val)
    write_attribute(:content, val)
  end

  def user_id
    read_attribute(:user_id)
  end

  def user_id=(val)
    write_attribute(:user_id, val)
    write_association(:user, UserMock.find(user_id)) if defined? UserMock
  end

  def up_votes
    read_attribute(:up_votes)
  end

  def up_votes=(val)
    write_attribute(:up_votes, val)
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
  def user
    @associations[:user]
  end

  def user=(val)
    @associations[:user] = val
    write_attribute(:user_id, val.id) if val.respond_to?(:persisted?) && val.persisted?
  end

  def build_user(attributes={}, &block)
    write_association(:user, UserMock.new(attributes, &block))
  end

  def create_user(attributes={}, &block)
    write_association(:user, UserMock.create(attributes, &block))
  end
  alias_method :create_user!, :create_user


  ##################################
  #  Model Methods getter/setters  #
  ##################################


  def display_name()
    block =  model_instance_methods['display_name']
    self.class.is_implemented(block, '#display_name')
    instance_exec(*[], &block)
  end

  def self.from_users_followed_by(user=nil)
    block =  model_class_methods['from_users_followed_by']
    is_implemented(block, '::from_users_followed_by')
    instance_exec(*[user], &block)
  end

  private

  def self.reload
    load __FILE__
  end

end