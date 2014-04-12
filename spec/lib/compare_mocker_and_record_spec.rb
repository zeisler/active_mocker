require 'rspec'
project_root = File.expand_path('../../../', __FILE__)
require "#{project_root}/lib/active_record/ar"
require "#{project_root}/lib/active_mocker"

describe 'Comparing ActiveMocker Api to ActiveRecord Api' do

  before(:each) do
    ActiveMocker::Base.configure do |config|
      config.schema_file = project_root + '/lib/active_record/db/schema.rb'
      config.model_dir   = project_root + '/lib/active_record/app/models'
      config.schema_file_reader  = nil
      config.model_file_reader   = nil
      config.active_hash_as_base = true
      config.log_level = Logger::WARN
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

    it 'they are the same' do
      expect(person_mock.attributes).to eq person_ar.attributes
    end

  end

  describe 'associations' do

    let(:zip_code){ZipCode.create(zip_code: '97023')}
    let(:create_attributes){attributes.merge({zip_code: zip_code})}

    let(:person_ar){Person.new(create_attributes)}
    let(:person_mock){PersonMock.new(create_attributes)}

    it 'the Mock when adding an association will not set the _id attribute, do it manually' do
      expect(person_mock.attributes).to eq({"id"=>nil, "company_id"=>nil, "first_name"=>"Dustin", "middle_name"=>nil, "last_name"=>"Zeisler", "address_1"=>nil, "address_2"=>nil, "city"=>nil, "state_id"=>nil, "zip_code_id"=>nil, "title"=>nil, "department"=>nil, "person_email"=>nil, "work_phone"=>nil, "cell_phone"=>nil, "home_phone"=>nil, "fax"=>nil, "user_id_assistant"=>nil, "birth_date"=>nil, "needs_review"=>nil, "created_at"=>nil, "updated_at"=>nil})
      expect(person_mock.zip_code).to eq zip_code
    end

    it 'Ar will not include associations in attributes' do
      expect(person_ar.attributes).to eq({"id"=>nil, "company_id"=>nil, "first_name"=>"Dustin", "middle_name"=>nil, "last_name"=>"Zeisler", "address_1"=>nil, "address_2"=>nil, "city"=>nil, "state_id"=>nil, "zip_code_id"=>2, "title"=>nil, "department"=>nil, "person_email"=>nil, "work_phone"=>nil, "cell_phone"=>nil, "home_phone"=>nil, "fax"=>nil, "user_id_assistant"=>nil, "birth_date"=>nil, "needs_review"=>nil, "created_at"=>nil, "updated_at"=>nil})
    end

  end

  describe 'column_names' do

    let(:column_names){["company_id", "first_name", "middle_name", "last_name", "address_1", "address_2", "city", "state_id", "zip_code_id", "title", "department", "person_email", "work_phone", "cell_phone", "home_phone", "fax", "user_id_assistant", "birth_date", "needs_review", "created_at", "updated_at"]}

    it 'they are the same' do
      expect(PersonMock.column_names).to eq Person.column_names
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