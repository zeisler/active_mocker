require 'active_mocker/mock_requires'
Object.send(:remove_const, "UserMock") if ActiveMocker.class_exists?("UserMock")

class UserMock < ::ActiveHash::Base
  include ActiveMocker::ActiveHash::ARApi
  include ActiveMocker::MockInstanceMethods
  extend  ActiveMocker::MockClassMethods

  def self.column_names
    ["id", "name", "email", "credits", "created_at", "updated_at", "password_digest", "remember_token", "admin"]
  end

  def self.attribute_names
    @attribute_names = [:id, :name, :email, :credits, :created_at, :updated_at, :password_digest, :remember_token, :admin]
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

  def name
    attributes['name']
  end

  def name=(val)
    @types ||= {}
    @types[:name] = Virtus::Attribute.build(String) unless @types[:name]
    attributes['name'] = @types[:name].coerce(val)
  end

  def email
    attributes['email']
  end

  def email=(val)
    @types ||= {}
    @types[:email] = Virtus::Attribute.build(String) unless @types[:email]
    attributes['email'] = @types[:email].coerce(val)
  end

  def credits
    attributes['credits']
  end

  def credits=(val)
    @types ||= {}
    @types[:credits] = Virtus::Attribute.build(BigDecimal) unless @types[:credits]
    attributes['credits'] = @types[:credits].coerce(val)
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

  def password_digest
    attributes['password_digest']
  end

  def password_digest=(val)
    @types ||= {}
    @types[:password_digest] = Virtus::Attribute.build(String) unless @types[:password_digest]
    attributes['password_digest'] = @types[:password_digest].coerce(val)
  end

  def remember_token
    attributes['remember_token']
  end

  def remember_token=(val)
    @types ||= {}
    @types[:remember_token] = Virtus::Attribute.build(String) unless @types[:remember_token]
    attributes['remember_token'] = @types[:remember_token].coerce(val)
  end

  def admin
    attributes['admin']
  end

  def admin=(val)
    @types ||= {}
    @types[:admin] = Virtus::Attribute.build(Virtus::Attribute::Boolean) unless @types[:admin]
    attributes['admin'] = @types[:admin].coerce(val)
  end

  ##################################
  #   Association getter/setters   #
  ##################################

  def self.association_names
    @association_names = [:microposts, :relationships, :followed_users, :reverse_relationships, :followers]
  end


  def microposts
    associations['microposts']
  end

  def microposts=(val)
    associations['microposts'] = ActiveMocker::CollectionAssociation.new(val)
  end

  def relationships
    associations['relationships']
  end

  def relationships=(val)
    associations['relationships'] = ActiveMocker::CollectionAssociation.new(val)
  end

  def followed_users
    associations['followed_users']
  end

  def followed_users=(val)
    associations['followed_users'] = ActiveMocker::CollectionAssociation.new(val)
  end

  def reverse_relationships
    associations['reverse_relationships']
  end

  def reverse_relationships=(val)
    associations['reverse_relationships'] = ActiveMocker::CollectionAssociation.new(val)
  end

  def followers
    associations['followers']
  end

  def followers=(val)
    associations['followers'] = ActiveMocker::CollectionAssociation.new(val)
  end

  ##################################
  #  Model Methods getter/setters  #
  ##################################

  def self.model_instance_methods
    return @model_instance_methods if @model_instance_methods
    @model_instance_methods = {}
    @model_instance_methods[:feed] = :not_implemented
    @model_instance_methods[:following?] = :not_implemented
    @model_instance_methods[:follow!] = :not_implemented
    @model_instance_methods[:unfollow!] = :not_implemented
    @model_instance_methods
  end

  def self.model_class_methods
    return @model_class_methods if @model_class_methods
    @model_class_methods = {}
    @model_class_methods[:new_remember_token] = :not_implemented
    @model_class_methods[:digest] = :not_implemented
    @model_class_methods
  end

  def self.clear_mock
    @model_class_methods, @model_instance_methods = nil, nil
    delete_all
  end

  def feed()
    block =  model_instance_methods[:feed]
    self.class.is_implemented(block, "#feed")
    instance_exec(*[], &block)
  end

  def following?(other_user)
    block =  model_instance_methods[:following?]
    self.class.is_implemented(block, "#following?")
    instance_exec(*[other_user], &block)
  end

  def follow!(other_user)
    block =  model_instance_methods[:follow!]
    self.class.is_implemented(block, "#follow!")
    instance_exec(*[other_user], &block)
  end

  def unfollow!(other_user)
    block =  model_instance_methods[:unfollow!]
    self.class.is_implemented(block, "#unfollow!")
    instance_exec(*[other_user], &block)
  end


  def self.new_remember_token()
    block =  model_class_methods[:new_remember_token]
    is_implemented(block, "::new_remember_token")
    instance_exec(*[], &block)
  end

  def self.digest(token)
    block =  model_class_methods[:digest]
    is_implemented(block, "::digest")
    instance_exec(*[token], &block)
  end


end
