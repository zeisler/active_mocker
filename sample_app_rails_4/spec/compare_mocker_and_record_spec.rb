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

    it 'mock' do
      expect(user_mock.attributes).to eq({"id" => nil, "name" => "Dustin Zeisler", "email" => "dustin@example.com", "credits" => nil, "created_at" => nil, "updated_at" => nil, "password_digest" => nil, "remember_token" => nil, "admin" => false})
    end

    it 'AR' do
      expect(user_ar.attributes).to eq({"id" => nil, "name" => "Dustin Zeisler", "email" => "dustin@example.com", "credits" => nil, "created_at" => nil, "updated_at" => nil, "password_digest" => nil, "remember_token" => nil, "admin" => false})
    end

  end

  describe 'associations' do

    let(:micropost){ Micropost.create(content: 'post')}
    let(:create_attributes){attributes.merge({microposts: [micropost]})}

    let(:user_ar){User.new(create_attributes)}
    let(:user_mock){UserMock.new(create_attributes)}

    it 'the Mock when adding an association will not set the _id attribute, do it manually' do
      expect(user_mock.attributes).to eq({"id" => nil, "name" => "Dustin Zeisler", "email" => "dustin@example.com", "credits" => nil, "created_at" => nil, "updated_at" => nil, "password_digest" => nil, "remember_token" => nil, "admin" => false})
      expect(user_mock.microposts).to eq [micropost]
    end

    it 'Ar will not include associations in attributes' do
      expect(user_ar.attributes).to eq({"id" => nil, "name" => "Dustin Zeisler", "email" => "dustin@example.com", "credits" => nil, "created_at" => nil, "updated_at" => nil, "password_digest" => nil, "remember_token" => nil, "admin" => false})
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

  describe 'type coercion' do

    it 'will coerce string to integer' do
      expect(Micropost.new(user_id: '1').user_id).to eq 1
      expect(MicropostMock.new(user_id: '1').user_id).to eq 1
    end

    it 'will coerce string to bool' do
      expect(User.new(admin: 'true').admin).to eq true
      expect(UserMock.new(admin: 'true').admin).to eq true
    end

    it 'will coerce string to decimal' do
      expect(User.new(credits: '12345').credits).to eq 12345.0
      expect(UserMock.new(credits: '12345').credits).to eq 12345.0
    end

    it 'will coerce string to datetime' do
      expect(User.new(created_at: '1/1/1990').created_at).to eq 'Mon, 01 Jan 1990 00:00:00 UTC +00:00'
      expect(UserMock.new(created_at: '1/1/1990').created_at).to eq 'Mon, 01 Jan 1990 00:00:00 UTC +00:00'
    end

    it 'will coerce integer to string' do
      expect(User.create(name: 1).reload.name).to eq '1'
      expect(UserMock.new(name: 1).name).to eq '1'
    end

  end

  describe 'CollectionAssociation' do

    let(:support_array_methods) { [:<<, :take, :push, :clear, :first, :last, :concat, :replace, :distinct, :uniq, :count, :size, :length, :empty?, :any?, :include?] }

    it 'supported array methods' do
      mp1 = Micropost.create!(content: 'text')
      mp2 = Micropost.create!(content: 'text')
      user = User.create(microposts: [mp1, mp2])

      mpm1 = MicropostMock.create
      mpm2 = MicropostMock.create
      user_mock = UserMock.create(microposts: [mpm1, mpm2])

      expect(user.microposts.methods).to include *support_array_methods
      expect(user_mock.microposts.methods).to include *support_array_methods
      expect(user.microposts.take(1).count).to eq(1)
      expect(user_mock.microposts.take(1).count).to eq(1)

    end

    it '#sum' do
      mp1 = Micropost.create!(content: 'text')
      mp2 = Micropost.create!(content: 'text')
      user = User.create(microposts: [mp1, mp2])
      expect(user.microposts.sum(:user_id)).to eq 2

      mpm1 = MicropostMock.create(user_id: 1)
      mpm2 = MicropostMock.create(user_id: 2)
      user_mock = UserMock.create(microposts: [mpm1, mpm2])

      expect(user_mock.microposts.sum(:user_id)).to eq 3

    end

  end

end