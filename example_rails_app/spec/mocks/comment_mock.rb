require 'active_mocker/mock'

class CommentMock < ActiveMocker::Mock::Base
  created_with('2.0.0-alpha.0')
# _modules_constants.erb

#_class_methods.erb
  class << self
    def attributes
      @attributes ||= HashWithIndifferentAccess.new({"id"=>nil, "user_id"=>nil, "text"=>nil, "votes"=>nil, "created_at"=>nil, "updated_at"=>nil}).merge(super)
    end

    def types
      @types ||= ActiveMocker::HashProcess.new({ id: Fixnum, user_id: Fixnum, text: String, votes: Fixnum, created_at: DateTime, updated_at: DateTime }, method(:build_type)).merge(super)
    end

    def associations
      @associations ||= {:user=>nil}.merge(super)
    end

    def associations_by_class
      @associations_by_class ||= {:User=>{:belongs_to=>[:user]}}.merge(super)
    end

    def mocked_class
      "Comment"
    end

    private :mocked_class

    def attribute_names
      @attribute_names ||= ["id", "user_id", "text", "votes", "created_at", "updated_at"] | super
    end

    def primary_key
      "id"
    end

    def abstract_class?
      false
    end

    def table_name
      "comments" || super
    end
  end
# _attributes.erb
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

# _associations.erb

# belongs_to
  def user
    read_association(:user) || write_association(:user, classes('User').try{ |k| k.find_by(id: user_id)})
  end
  def user=(val)
    write_association(:user, val)
    ActiveMocker::BelongsTo.new(val, child_self: self, foreign_key: :user_id).item
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



# _scopes.erb
  module Scopes
    include ActiveMocker::Base::Scopes

  end

  extend Scopes

  class ScopeRelation < ActiveMocker::Association
    include CommentMock::Scopes
  end

  def self.__new_relation__(collection)
    CommentMock::ScopeRelation.new(collection)
  end

  private_class_method :__new_relation__

end
