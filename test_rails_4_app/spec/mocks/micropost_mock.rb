require 'active_mocker/mock'

class MicropostMock < ActiveMocker::Mock::Base
  created_with('1.8.3')
  MAGIC_ID_NUMBER = 90
  MAGIC_ID_STRING = "F-1"
  prepend PostMethods
  extend  PostMethods

  class << self

    def attributes
      @attributes ||= HashWithIndifferentAccess.new({"id"=>nil, "content"=>nil, "user_id"=>nil, "up_votes"=>nil, "created_at"=>nil, "updated_at"=>nil}).merge(super)
    end

    def types
      @types ||= ActiveMocker::Mock::HashProcess.new({ id: Fixnum, content: String, user_id: Fixnum, up_votes: Fixnum, created_at: DateTime, updated_at: DateTime }, method(:build_type)).merge(super)
    end

    def associations
      @associations ||= {:user=>nil}.merge(super)
    end

    def associations_by_class
      @associations_by_class ||= {"User"=>{:belongs_to=>[:user]}}.merge(super)
    end

    def mocked_class
      "Micropost"
    end

    private :mocked_class

    def attribute_names
      @attribute_names ||= ["id", "content", "user_id", "up_votes", "created_at", "updated_at"] | super
    end

    def primary_key
      "id"
    end

    def abstract_class?
      false
    end

    def table_name
      "microposts" || super
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
    read_association(:user) || write_association(:user, classes('User').try{ |k| k.find_by(id: user_id)})
  end

  def user=(val)
    write_association(:user, val)
    ActiveMocker::Mock::BelongsTo.new(val, child_self: self, foreign_key: :user_id).item
  end

  def build_user(attributes={}, &block)
    association = classes('User').try(:new, attributes, &block)
    write_association(:user, association) unless association.nil?
  end

  def create_user(attributes={}, &block)
    association = classes('User').try(:create,attributes, &block)
    write_association(:user, association) unless association.nil?
  end
  alias_method :create_user!, :create_user


  module Scopes
    include ActiveMocker::Mock::Base::Scopes

  end

  extend Scopes

  class ScopeRelation < ActiveMocker::Mock::Association
    include MicropostMock::Scopes
  end

  private

  def self.new_relation(collection)
    MicropostMock::ScopeRelation.new(collection)
  end

  public

  ##################################
  #        Model Methods           #
  ##################################


  def display_name
    call_mock_method :display_name, Kernel.caller
  end

  def post_id
    call_mock_method :post_id, Kernel.caller
  end

  def self.from_users_followed_by(user=nil)
    call_mock_method :from_users_followed_by, Kernel.caller, user
  end

end