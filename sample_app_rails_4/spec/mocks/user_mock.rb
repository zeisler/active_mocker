require 'active_mocker/mock_requires'
Object.send(:remove_const, "UserMock") if Object.const_defined?("UserMock")

class UserMock < ActiveMocker::Base

  def initialize(attributes={}, &block)
    @attributes = HashWithIndifferentAccess.new({"id"=>nil, "name"=>nil, "email"=>"", "credits"=>nil, "created_at"=>nil, "updated_at"=>nil, "password_digest"=>nil, "remember_token"=>true, "admin"=>false})
    @associations = HashWithIndifferentAccess.new({:microposts=>nil, :relationships=>nil, :followed_users=>nil, :reverse_relationships=>nil, :followers=>nil})
    super(attributes, &block)
  end

  def self.mocked_class
    'User'
  end

  def self.column_names
    ["id", "name", "email", "credits", "created_at", "updated_at", "password_digest", "remember_token", "admin"]
  end

  def self.attribute_names
    @attribute_names = ["id", "name", "email", "credits", "created_at", "updated_at", "password_digest", "remember_token", "admin"]
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

  def name
    @attributes['name']
  end

  def name=(val)
    type = (types[:name] ||= Virtus::Attribute.build(String))
    @attributes['name'] = type.coerce(val)
          end

  def email
    @attributes['email']
  end

  def email=(val)
    type = (types[:email] ||= Virtus::Attribute.build(String))
    @attributes['email'] = type.coerce(val)
          end

  def credits
    @attributes['credits']
  end

  def credits=(val)
    type = (types[:credits] ||= Virtus::Attribute.build(BigDecimal))
    @attributes['credits'] = type.coerce(val)
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

  def password_digest
    @attributes['password_digest']
  end

  def password_digest=(val)
    type = (types[:password_digest] ||= Virtus::Attribute.build(String))
    @attributes['password_digest'] = type.coerce(val)
          end

  def remember_token
    @attributes['remember_token']
  end

  def remember_token=(val)
    type = (types[:remember_token] ||= Virtus::Attribute.build(Axiom::Types::Boolean))
    @attributes['remember_token'] = type.coerce(val)
          end

  def admin
    @attributes['admin']
  end

  def admin=(val)
    type = (types[:admin] ||= Virtus::Attribute.build(Axiom::Types::Boolean))
    @attributes['admin'] = type.coerce(val)
          end

  ##################################
  #         Associations           #
  ##################################
# belongs_to
# has_one
# has_many

  def microposts
    associations['microposts'] ||= ActiveMocker::HasMany.new([],'user_id', @attributes['id'], 'MicropostMock')
  end

  def microposts=(val)
    associations['microposts'] ||= ActiveMocker::HasMany.new(val,'user_id', @attributes['id'], 'MicropostMock')
  end

  def relationships
    associations['relationships'] ||= ActiveMocker::HasMany.new([],'follower_id', @attributes['id'], 'RelationshipMock')
  end

  def relationships=(val)
    associations['relationships'] ||= ActiveMocker::HasMany.new(val,'follower_id', @attributes['id'], 'RelationshipMock')
  end

  def followed_users
    associations['followed_users'] ||= ActiveMocker::HasMany.new([],'user_id', @attributes['id'], 'FollowedUserMock')
  end

  def followed_users=(val)
    associations['followed_users'] ||= ActiveMocker::HasMany.new(val,'user_id', @attributes['id'], 'FollowedUserMock')
  end

  def reverse_relationships
    associations['reverse_relationships'] ||= ActiveMocker::HasMany.new([],'followed_id', @attributes['id'], 'RelationshipMock')
  end

  def reverse_relationships=(val)
    associations['reverse_relationships'] ||= ActiveMocker::HasMany.new(val,'followed_id', @attributes['id'], 'RelationshipMock')
  end

  def followers
    associations['followers'] ||= ActiveMocker::HasMany.new([],'user_id', @attributes['id'], 'FollowerMock')
  end

  def followers=(val)
    associations['followers'] ||= ActiveMocker::HasMany.new(val,'user_id', @attributes['id'], 'FollowerMock')
  end
# has_and_belongs_to_many

  ##################################
  #  Model Methods getter/setters  #
  ##################################

  def self.model_instance_methods
    @model_instance_methods ||= {"feed"=>:not_implemented, "following?"=>:not_implemented, "follow!"=>:not_implemented, "unfollow!"=>:not_implemented}
  end

  def self.model_class_methods
    @model_class_methods ||= {"new_remember_token"=>:not_implemented, "digest"=>:not_implemented}
  end

  def self.clear_mock
    @foreign_keys,@model_class_methods, @model_instance_methods = nil, nil, nil
    delete_all
  end

  def feed()
    block =  model_instance_methods['feed']
    self.class.is_implemented(block, '#feed')
    instance_exec(*[], &block)
  end

  def following?(other_user)
    block =  model_instance_methods['following?']
    self.class.is_implemented(block, '#following?')
    instance_exec(*[other_user], &block)
  end

  def follow!(other_user)
    block =  model_instance_methods['follow!']
    self.class.is_implemented(block, '#follow!')
    instance_exec(*[other_user], &block)
  end

  def unfollow!(other_user)
    block =  model_instance_methods['unfollow!']
    self.class.is_implemented(block, '#unfollow!')
    instance_exec(*[other_user], &block)
  end

  def self.new_remember_token()
    block =  model_class_methods['new_remember_token']
    is_implemented(block, '::new_remember_token')
    instance_exec(*[], &block)
  end

  def self.digest(token)
    block =  model_class_methods['digest']
    is_implemented(block, '::digest')
    instance_exec(*[token], &block)
  end

  def self.reload
    load __FILE__
  end

end