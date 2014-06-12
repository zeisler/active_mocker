require 'active_mocker/mock_requires'
Object.send(:remove_const, "Relationship") if Object.const_defined?("Relationship")

class RelationshipMock < ActiveMocker::Base

  def initialize(attributes={}, &block)
    @attributes = HashWithIndifferentAccess.new({"id"=>nil, "follower_id"=>nil, "followed_id"=>nil, "created_at"=>nil, "updated_at"=>nil})
    @associations = HashWithIndifferentAccess.new({:follower=>nil, :followed=>nil})
    super(attributes, &block)
  end

  def self.mocked_class
    'Relationship'
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
                associations['follower'] = UserMock.find(val) if defined? UserMock
      end

  def followed_id
    @attributes['followed_id']
  end

  def followed_id=(val)
    type = (types[:followed_id] ||= Virtus::Attribute.build(Fixnum))
    @attributes['followed_id'] = type.coerce(val)
                associations['followed'] = UserMock.find(val) if defined? UserMock
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
  #         Associations           #
  ##################################
# belongs_to

  def follower
    associations['follower']
  end

  def follower=(val)
    associations['follower'] = val
    write_attribute('follower_id', val.id) if val.respond_to?(:persisted?) && val.persisted?
  end

  def followed
    associations['followed']
  end

  def followed=(val)
    associations['followed'] = val
    write_attribute('followed_id', val.id) if val.respond_to?(:persisted?) && val.persisted?
  end
# has_one
# has_many
# has_and_belongs_to_many

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
    @foreign_keys,@model_class_methods, @model_instance_methods = nil, nil, nil
    delete_all
  end

  def self.reload
    load __FILE__
  end

end