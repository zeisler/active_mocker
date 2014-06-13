require 'rspec'
$:.unshift File.expand_path('../../', __FILE__)
require 'active_support'
require 'spec/mocks/user_mock.rb'
APP_ROOT =  File.expand_path('../../', __FILE__) unless defined? APP_ROOT
require 'config/initializers/active_mocker.rb'
require 'forwardable'

describe 'UserMock' do

  before(:each){
    ActiveMocker::Generate.new
    UserMock.clear_mock
  }

  describe '::mocked_class' do

    it 'returns the name of the class being mocked' do
      expect(UserMock.mocked_class).to eq 'User'
    end

  end

  describe 'ActiveMocker::LoadedMocks' do

    it 'will be added when sub classed' do
      expect(ActiveMocker::LoadedMocks.all.keys.include?('UserMock')).to eq true
    end

  end


  describe '::column_names' do

    it 'returns an array of column names found from the schema.rb file' do
      expect(UserMock.column_names).to eq(["id", "name", "email", "credits", "created_at", "updated_at", "password_digest", "remember_token", "admin"])
    end

  end

  describe 'mass_assignment' do

    it "can pass any or all attributes from schema in initializer" do
      result = UserMock.new(name: "Sam", email: 'Walton')
      expect(result.name).to eq 'Sam'
      expect(result.email).to eq 'Walton'
    end

    it 'will raise error if not an attribute or association' do
      expect{UserMock.new(baz: "Hello")}.to raise_error(ActiveMock::RejectedParams, '{:baz=>"Hello"} for UserMock')
    end

  end

  describe 'relationships' do

    it 'add instance methods from model relationships' do
      result = UserMock.new(followers: [1])
      expect(result.followers).to eq [1]
    end

    it 'add has_many relationship' do
      expect(UserMock.new.microposts.count).to eq 0
      mock_inst = UserMock.new
      mock_inst.microposts << 1
      expect(mock_inst.microposts.count).to eq 1
      mock_inst.microposts << 1
      expect(mock_inst.microposts.count).to eq 2
      expect(mock_inst.microposts.to_a).to eq [1, 1]
    end

  end

  describe 'instance methods' do

    it 'will raise exception for unimplemented methods' do
      expect(UserMock.new.method(:following?).parameters).to eq  [[:req, :other_user]]
      expect{UserMock.new.following?}.to raise_error ArgumentError
      expect{UserMock.new.following?('foo')}.to raise_error(RuntimeError, '#following? is not Implemented for Class: UserMock')
    end

    it 'can be implemented dynamically' do

      UserMock.mock_instance_method(:follow!) do  |other_user|
        "Now implemented with #{other_user}"
      end
      result = UserMock.new
      result = result.follow!('foo')
      expect(result).to eq "Now implemented with foo"

    end

    it 'can reference another mock' do

      UserMock.mock_instance_method(:following?) do  |person|
        true
      end

      UserMock.mock_instance_method(:follow!) do |person|
        following?(person)
      end

      expect(UserMock.new.follow!("name")).to eq true
      expect(UserMock.new.following?(1)).to eq true
    end

  end

  describe 'class methods' do

    it 'will raise exception for unimplemented methods' do
      expect{UserMock.new_remember_token}.to raise_error('::new_remember_token is not Implemented for Class: UserMock')
    end

    it 'can be implemented as follows' do

      UserMock.mock_class_method(:new_remember_token) do
        "Now implemented"
      end
      expect{UserMock.new_remember_token}.to_not raise_error
      expect(UserMock.new_remember_token).to eq("Now implemented")

    end

  end

  context 'active_mock' do

    it 'uses active_mock::base as superclass' do
      expect(UserMock.superclass.name).to eq 'ActiveMock::Base'
    end

    it 'can save to class and then find instance by attribute' do
      record = UserMock.create(name: "Sam")
      expect(UserMock.find_by(name:"Sam")).to eq record

    end

    it '#update' do

      person = UserMock.create(name: 'Justin')
      expect(UserMock.first.name).to eq 'Justin'
      person.update(name: 'Dustin')
      expect(UserMock.first.name).to eq 'Dustin'

      expect(person.name).to eq 'Dustin'

    end

    it '::destroy_all' do

      UserMock.create

      expect(UserMock.count).to eq 1

      UserMock.destroy_all

      expect(UserMock.count).to eq 0

    end

    it '::find_by' do
      person = UserMock.create(name: 'dustin')
      expect(UserMock.find_by(name: 'dustin')).to eq person
    end

    it '::find_or_create_by' do
      person = UserMock.find_or_create_by(name: 'dustin')
      expect(UserMock.find_by(name: 'dustin')).to eq person
      person = UserMock.find_or_create_by(name: 'dustin')
      expect(UserMock.count).to eq 1
    end

    it '::find_or_create_by with update' do
      UserMock.create(name: 'dustin')
      person = UserMock.find_or_create_by(name: 'dustin')
      person.update(email: 'Zeisler')
      expect(UserMock.first.attributes).to eq person.attributes
      expect(UserMock.count).to eq 1
    end

    it '::find_or_initialize_by' do
      person = UserMock.find_or_initialize_by(name: 'dustin')
      expect(person.persisted?).to eq false
      UserMock.create(name: 'dustin')
      person = UserMock.find_or_initialize_by(name: 'dustin')
      expect(person.persisted?).to eq true
    end


    after(:each) do
      UserMock.delete_all
    end

  end

end