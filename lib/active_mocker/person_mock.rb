require 'active_mocker/mock_instance_methods'
require 'active_mocker/mock_class_methods'
require 'active_hash'
require 'active_hash/ar_api'

class PersonMock < ::ActiveHash::Base
  include ActiveMocker::ActiveHash::ARApi
  include ActiveMocker::MockInstanceMethods
  extend  ActiveMocker::MockClassMethods

  def self.column_names
    ["id", "company_id", "first_name", "middle_name", "last_name", "address_1", "address_2", "city", "state_id", "zip_code_id", "title", "department", "person_email", "work_phone", "cell_phone", "home_phone", "fax", "user_id_assistant", "birth_date", "needs_review", "created_at", "updated_at"]
  end

  def self.association_names
    @association_names = []
  end

  def self.attribute_names
    @attribute_names = [:id, :company_id, :first_name, :middle_name, :last_name, :address_1, :address_2, :city, :state_id, :zip_code_id, :title, :department, :person_email, :work_phone, :cell_phone, :home_phone, :fax, :user_id_assistant, :birth_date, :needs_review, :created_at, :updated_at]
  end


  def id
    attributes['id']
  end

  def id=(val)
    attributes['id'] = val
  end

  def company_id
    attributes['company_id']
  end

  def company_id=(val)
    attributes['company_id'] = val
  end

  def first_name
    attributes['first_name']
  end

  def first_name=(val)
    attributes['first_name'] = val
  end

  def middle_name
    attributes['middle_name']
  end

  def middle_name=(val)
    attributes['middle_name'] = val
  end

  def last_name
    attributes['last_name']
  end

  def last_name=(val)
    attributes['last_name'] = val
  end

  def address_1
    attributes['address_1']
  end

  def address_1=(val)
    attributes['address_1'] = val
  end

  def address_2
    attributes['address_2']
  end

  def address_2=(val)
    attributes['address_2'] = val
  end

  def city
    attributes['city']
  end

  def city=(val)
    attributes['city'] = val
  end

  def state_id
    attributes['state_id']
  end

  def state_id=(val)
    attributes['state_id'] = val
  end

  def zip_code_id
    attributes['zip_code_id']
  end

  def zip_code_id=(val)
    attributes['zip_code_id'] = val
  end

  def title
    attributes['title']
  end

  def title=(val)
    attributes['title'] = val
  end

  def department
    attributes['department']
  end

  def department=(val)
    attributes['department'] = val
  end

  def person_email
    attributes['person_email']
  end

  def person_email=(val)
    attributes['person_email'] = val
  end

  def work_phone
    attributes['work_phone']
  end

  def work_phone=(val)
    attributes['work_phone'] = val
  end

  def cell_phone
    attributes['cell_phone']
  end

  def cell_phone=(val)
    attributes['cell_phone'] = val
  end

  def home_phone
    attributes['home_phone']
  end

  def home_phone=(val)
    attributes['home_phone'] = val
  end

  def fax
    attributes['fax']
  end

  def fax=(val)
    attributes['fax'] = val
  end

  def user_id_assistant
    attributes['user_id_assistant']
  end

  def user_id_assistant=(val)
    attributes['user_id_assistant'] = val
  end

  def birth_date
    attributes['birth_date']
  end

  def birth_date=(val)
    attributes['birth_date'] = val
  end

  def needs_review
    attributes['needs_review']
  end

  def needs_review=(val)
    attributes['needs_review'] = val
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






  def self.mock_instance_methods
    return @mock_instance_methods if @mock_instance_methods
    @mock_instance_methods = {}
      @mock_instance_methods[:bar] = :not_implemented
    
      @mock_instance_methods[:baz] = :not_implemented
    
    @mock_instance_methods
  end

  def self.mock_class_methods
    return @mock_class_methods if @mock_class_methods
    @mock_class_methods = {}
    @mock_class_methods
  end


  def bar(name, type=nil)
    block =  mock_instance_methods[:bar]
    self.class.is_implemented(block, "#bar")
    instance_exec(*[name, type], &block)
  end

  def baz()
    block =  mock_instance_methods[:baz]
    self.class.is_implemented(block, "#baz")
    instance_exec(*[], &block)
  end




end