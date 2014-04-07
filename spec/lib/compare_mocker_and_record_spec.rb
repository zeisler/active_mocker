require 'rspec'
project_root = File.expand_path('../../../', __FILE__)
require "#{project_root}/lib/active_record/ar"
require "#{project_root}/lib/active_mocker"

describe 'Comparing ActiveMocker Api to ActiveRecord Api' do

  before(:each) do
    ActiveMocker::Base.configure do |config|
      # Required Options
      config.schema_file = project_root + '/lib/active_record/db/schema.rb'
      config.model_dir   = project_root + '/lib/active_record/app/models'
      # Additional Options
      # Dependency injection
      config.schema_file_reader = nil
      config.model_file_reader  = nil
      config.active_hash_as_base = true #default
      #config.schema_attributes   = true  #default
      #config.model_relationships = true  #default
      #config.model_methods       = true  #default
      #config.mass_assignment     = true  #default
      # Logging
      config.log_level = Logger::WARN       #default
    end
    ActiveMocker::Base.mock('Person')
  end

  after(:each) do
    PersonMock.destroy_all
    Person.destroy_all
  end

  let(:attributes){{first_name: 'Dustin', last_name: 'Zeisler'}}

  describe '::superclass' do

    it 'mock has super of active hash' do
      expect(PersonMock.superclass.name).to eq "ActiveHash::Base"
    end

    it 'ar has super of ar' do
      expect(Person.superclass.name).to eq "ActiveRecord::Base"

    end

  end

  describe '::create' do

    let(:create_attributes){attributes}

    it 'mock will take all attributes that AR takes' do

      person = Person.create(create_attributes)
      person_mock = PersonMock.create(create_attributes)

    end

  end

  describe '#attributes' do

    let(:person_ar){Person.new(attributes)}
    let(:person_mock){PersonMock.new(attributes)}

    # DO NOT depend on the fact that attributes to be the same as AR
    # Work Around: seed all unused values with nil
    # Implementation Fix: On init give all values nil

    it 'the mock will exclude any attributes with nil and have a symbol and string version' do
      expect(person_mock.attributes).to eq({:first_name=>"Dustin", :last_name=>"Zeisler", "first_name"=>"Dustin", "last_name"=>"Zeisler"})
    end

    it 'can still ask for attribute that is nil on mock' do
      expect(person_mock[:middle_name]).to eq(nil)
    end

    it 'ar will include values with nil' do
      expect(person_ar.attributes).to eq({"id"=>nil, "company_id"=>nil, "first_name"=>"Dustin", "middle_name"=>nil, "last_name"=>"Zeisler", "address_1"=>nil, "address_2"=>nil, "city"=>nil, "state_id"=>nil, "zip_code_id"=>nil, "title"=>nil, "department"=>nil, "person_email"=>nil, "work_phone"=>nil, "cell_phone"=>nil, "home_phone"=>nil, "fax"=>nil, "user_id_assistant"=>nil, "birth_date"=>nil, "needs_review"=>nil, "created_at"=>nil, "updated_at"=>nil})
    end

    it 'compare access to attribute' do
      expect(person_mock.first_name).to eq person_ar.first_name
      expect(person_mock[:first_name]).to eq person_ar.first_name
      expect(person_mock['first_name']).to eq person_ar.first_name
      expect(person_ar[:first_name]).to eq person_mock.first_name
    end


  end

  describe 'associations' do

    let(:zip_code){ZipCode.create(zip_code: '97023')}
    let(:create_attributes){attributes.merge({zip_code: zip_code})}

    let(:person_ar){Person.new(create_attributes)}
    let(:person_mock){PersonMock.new(create_attributes)}

    # DO NOT Depend on this or your code will break in production
    # Work Around: To access associations call method
    # Implementation Fix: remove association from fields and make getter and setter method

    it 'The Mock will include associations in attributes' do
      expect(person_mock.attributes).to eq({:first_name=>"Dustin", :last_name=>"Zeisler", zip_code: zip_code, "first_name"=>"Dustin", "last_name"=>"Zeisler"})
    end

    it 'Ar will not include associations in attributes' do
      expect(person_ar.attributes).to eq({"id"=>nil, "company_id"=>nil, "first_name"=>"Dustin", "middle_name"=>nil, "last_name"=>"Zeisler", "address_1"=>nil, "address_2"=>nil, "city"=>nil, "state_id"=>nil, "zip_code_id"=>2, "title"=>nil, "department"=>nil, "person_email"=>nil, "work_phone"=>nil, "cell_phone"=>nil, "home_phone"=>nil, "fax"=>nil, "user_id_assistant"=>nil, "birth_date"=>nil, "needs_review"=>nil, "created_at"=>nil, "updated_at"=>nil})
    end

  end

  describe 'column_names' do

    let(:column_names){["company_id", "first_name", "middle_name", "last_name", "address_1", "address_2", "city", "state_id", "zip_code_id", "title", "department", "person_email", "work_phone", "cell_phone", "home_phone", "fax", "user_id_assistant", "birth_date", "needs_review", "created_at", "updated_at"]}

    it 'mock does not include id column' do
      expect(PersonMock.column_names).to eq column_names
    end

    it 'AR does include id column' do
      expect(Person.column_names).to eq column_names.unshift('id')
    end

  end

  describe '::find_by' do

    let!(:ar_record){Person.create(attributes)}
    let!(:mock_record){PersonMock.create(attributes)}
    let!(:mock_record_2){PersonMock.create(attributes.merge({title: 'Developer'}))}

    it 'AR' do
      expect(ar_record).to eq Person.find_by(first_name: 'Dustin', last_name: 'Zeisler')
    end

    it 'Mock' do
      PersonMock.create(first_name: 'Dustin', last_name: 'Zeisler', title: 'Developer')
      expect(PersonMock.create(title: 'Developer', first_name: 'Dustin', last_name: 'Adams')).to eq PersonMock.find_by(title: 'Developer', last_name: 'Adams')
    end

  end

  describe '::where' do

    let(:ar_record){Person.create(attributes)}
    let(:mock_record){PersonMock.create(attributes)}
    let(:mock_record_2){PersonMock.create(attributes.merge(title: 'Developer'))}

    it 'AR' do
      expect([ar_record]).to eq Person.where(first_name: 'Dustin', last_name: 'Zeisler')
    end

    it 'Mock' do
      expect([mock_record]).to eq PersonMock.where(first_name: 'Dustin', last_name: 'Zeisler')
    end

    it 'Mock will not take sql string needs to be mocked' do
      PersonMock.create(first_name: 'Dustin', last_name: 'Zeisler', title: 'Developer')
      expect{PersonMock.where("first_name = 'Dustin'")}.to raise_error
    end

  end


end