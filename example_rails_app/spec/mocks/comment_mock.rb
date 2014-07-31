require 'active_mocker/mock'
Object.send(:remove_const, "CommentMock") if Object.const_defined?("CommentMock")

class CommentMock < ActiveMocker::Mock::Base

  class << self

    def attributes
      @attributes ||= HashWithIndifferentAccess.new({"id"=>nil, "user_id"=>nil, "text"=>nil, "votes"=>nil, "created_at"=>nil, "updated_at"=>nil})
    end

    def types
      @types ||= ActiveMocker::Mock::HashProcess.new({ id: Fixnum, user_id: Fixnum, text: String, votes: Fixnum, created_at: DateTime, updated_at: DateTime }, method(:build_type))
    end

    def associations
      @associations ||= {:user=>nil}
    end

    def mocked_class
      'Comment'
    end

    private :mocked_class

    def attribute_names
      @attribute_names ||= ["id", "user_id", "text", "votes", "created_at", "updated_at"]
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

  def user_id
    read_attribute(:user_id)
  end

  def user_id=(val)
    write_attribute(:user_id, val)
    association = classes('User').try(:find_by, id: user_id)
    write_association(:user,association) unless association.nil?
  end

  def text
    read_attribute(:text)
  end

  def text=(val)
    write_attribute(:text, val)
  end

  def votes
    read_attribute(:votes)
  end

  def votes=(val)
    write_attribute(:votes, val)
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
    if ActiveMocker::Mock.config.experimental
      val.comments << self if val.respond_to?(:comments=)
      val.comment = self if val.respond_to?(:comment=)
    end
    val
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

  end

  extend Scopes

  class ScopeRelation < ActiveMocker::Mock::Association
    include CommentMock::Scopes
  end

  private

  def self.new_relation(collection)
    CommentMock::ScopeRelation.new(collection)
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