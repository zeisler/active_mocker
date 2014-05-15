require 'rspec'
$:.unshift File.expand_path('../', __FILE__)
load 'mocks/user_mock.rb'

describe UserMock do

  let(:mock_class){described_class}

  describe '::column_names' do

    it 'returns an array of column names found from the schema.rb file' do
      expect(mock_class.column_names).to eq(["id", "name", "email", "created_at", "updated_at", "password_digest", "remember_token", "admin"])
    end

  end

  describe 'mass_assignment' do

    it "can pass any or all attributes from schema in initializer" do
      result = mock_class.new(name: "Sam", email: 'Walton')
      expect(result.name).to eq 'Sam'
      expect(result.email).to eq 'Walton'
    end

    it 'will raise error if not an attribute or association' do
      expect{mock_class.new(baz: "Hello")}.to raise_error('Rejected params: {"baz"=>"Hello"} for UserMock')
    end

  end

  describe 'relationships' do

    it 'add instance methods from model relationships' do
      result = mock_class.new(followers: [1])
      expect(result.followers).to eq [1]
    end

    it 'add has_many relationship' do

      expect(mock_class.new.microposts.class).to eq ActiveMocker::CollectionAssociation
      expect(mock_class.new.microposts.count).to eq 0
      mock_inst = mock_class.new
      mock_inst.microposts << 1
      expect(mock_inst.microposts.count).to eq 1

    end

  end

  describe 'instance methods' do

    it 'will raise exception for unimplemented methods' do
      expect(mock_class.new.method(:following?).parameters).to eq  [[:req, :other_user]]
      expect{mock_class.new.following?}.to raise_error ArgumentError
      expect{mock_class.new.following?('foo')}.to raise_error(RuntimeError, '#following? is not Implemented for Class: UserMock')
    end

    it 'can be implemented dynamically' do

      mock_class.mock_instance_method(:follow!) do  |other_user|
        "Now implemented with #{other_user}"
      end
      result = mock_class.new
      result = result.follow!('foo')
      expect(result).to eq "Now implemented with foo"

    end

    it 'can reference another mock' do

      mock_class.mock_instance_method(:following?) do  |person|
        true
      end

      mock_class.mock_instance_method(:follow!) do |person|
        following?(person)
      end

      expect(mock_class.new.follow!("name")).to eq true
      expect(mock_class.new.following?(1)).to eq true
    end

  end

  describe 'class methods' do

    it 'will raise exception for unimplemented methods' do
      expect{mock_class.new_remember_token}.to raise_error('::new_remember_token is not Implemented for Class: UserMock')
    end

    it 'can be implemented as follows' do

      mock_class.mock_class_method(:new_remember_token) do
        "Now implemented"
      end
      expect{mock_class.new_remember_token}.to_not raise_error
      expect(mock_class.new_remember_token).to eq("Now implemented")

    end

  end

  context 'active_hash' do

    it 'uses active_hash::base as superclass' do
      expect(mock_class.superclass.name).to eq 'ActiveHash::Base'
    end

    it 'can save to class and then find instance by attribute' do
      record = mock_class.create(name: "Sam")
      expect(mock_class.find_by(name:"Sam")).to eq record

    end

    it '#update' do

      person = mock_class.create(name: 'Justin')

      expect(UserMock.first.name).to eq 'Justin'
      person.update(name: 'Dustin')
      expect(UserMock.first.name).to eq 'Dustin'

      expect(person.name).to eq 'Dustin'

    end

    it '::destroy_all' do

      mock_class.create

      expect(mock_class.count).to eq 1

      mock_class.destroy_all

      expect(mock_class.count).to eq 0

    end

    it '::find_by' do
      person = mock_class.create(name: 'dustin')
      expect(mock_class.find_by(name: 'dustin')).to eq person
    end

    it '::find_or_create_by' do
      person = mock_class.find_or_create_by(name: 'dustin')
      expect(mock_class.find_by(name: 'dustin')).to eq person
      person = mock_class.find_or_create_by(name: 'dustin')
      expect(mock_class.count).to eq 1
    end

    it '::find_or_create_by with update' do
      mock_class.create(name: 'dustin')
      person = mock_class.find_or_create_by(name: 'dustin')
      person.update(email: 'Zeisler')
      expect(mock_class.first.attributes).to eq person.attributes
      expect(mock_class.count).to eq 1
    end

    it '::find_or_initialize_by' do
      person = mock_class.find_or_initialize_by(name: 'dustin')
      expect(person.persisted?).to eq false
      mock_class.create(name: 'dustin')
      person = mock_class.find_or_initialize_by(name: 'dustin')
      expect(person.persisted?).to eq true
    end

    after(:each) do
      mock_class.delete_all
    end

  end

end