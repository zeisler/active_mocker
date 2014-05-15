$:.unshift File.expand_path('../', __FILE__)
require 'spec_helper'
load 'mocks/user_mock.rb'
load 'mocks/micropost_mock.rb'

describe 'Comparing ActiveMocker Api to ActiveRecord Api' do

  after(:each) do
    UserMock.destroy_all
    User.destroy_all
    MicropostMock.destroy_all
    Micropost.destroy_all
  end

  let(:attributes) { {name: 'Dustin Zeisler', email: 'dustin@example.com'} }
  let(:attributes_with_admin) { {name: 'Dustin Zeisler', email: 'dustin@example.com', admin: true} }

  describe '::superclass' do

    it 'mock has super of active hash' do
      expect(UserMock.superclass.name).to eq "ActiveHash::Base"
    end

    it 'ar has super of ar' do
      expect(User.superclass.name).to eq "ActiveRecord::Base"
    end

  end

  describe '::create' do

    let(:create_attributes){attributes}

    it 'mock will take all attributes that AR takes' do
      User.create(create_attributes)
      UserMock.create(create_attributes)
    end

  end

  describe '#attributes' do

    let(:user_ar){User.new(attributes)}
    let(:user_mock){UserMock.new(attributes)}

    it 'they are the same' do
      expect(user_mock.attributes).to eq user_ar.attributes
    end

  end

  describe 'associations' do

    let(:micropost){ Micropost.create(content: 'post')}
    let(:create_attributes){attributes.merge({microposts: [micropost]})}

    let(:user_ar){User.new(create_attributes)}
    let(:user_mock){UserMock.new(create_attributes)}

    it 'the Mock when adding an association will not set the _id attribute, do it manually' do
      expect(user_mock.attributes).to eq({"id" => nil, "name" => "Dustin Zeisler", "email" => "dustin@example.com", "created_at" => nil, "updated_at" => nil, "password_digest" => nil, "remember_token" => nil, "admin" => nil})
      expect(user_mock.microposts).to eq [micropost]
    end

    it 'Ar will not include associations in attributes' do
      expect(user_ar.attributes).to eq({"id" => nil, "name" => "Dustin Zeisler", "email" => "dustin@example.com", "created_at" => nil, "updated_at" => nil, "password_digest" => nil, "remember_token" => nil, "admin" => nil})
      expect(user_ar.microposts).to eq [micropost]
    end

  end

  describe 'column_names' do

    it 'they are the same' do
      expect(UserMock.column_names).to eq User.column_names
    end

  end

  describe '::find_by' do

    let!(:ar_record){User.create(attributes)}
    let!(:mock_record){UserMock.create(attributes)}

    it 'AR' do
      expect(ar_record).to eq User.find_by(attributes)
    end

    it 'Mock' do
      expect(UserMock.create(attributes_with_admin)).to eq UserMock.find_by(attributes_with_admin)
    end

  end

  describe '::where' do

    let(:ar_record){User.create(attributes)}
    let(:mock_record){UserMock.create(attributes)}
    let(:mock_record_2){UserMock.create(attributes_with_admin)}

    it 'AR' do
      expect([ar_record]).to eq User.where(attributes)
    end

    it 'Mock' do
      expect([mock_record]).to eq UserMock.where(attributes)
    end

    it 'Mock will not take sql string needs to be mocked' do
      UserMock.create(attributes_with_admin)
      expect{UserMock.where("name = 'Dustin Zeisler'")}.to raise_error
    end

  end

end