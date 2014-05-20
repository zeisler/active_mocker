$:.unshift File.expand_path('../', __FILE__)
require 'spec_helper'
load 'mocks/user_mock.rb'
load 'mocks/micropost_mock.rb'

describe 'Comparing ActiveMocker Api to ActiveRecord Api' do

  before(:each) do
    User.destroy_all
    UserMock.destroy_all
    MicropostMock.destroy_all
    Micropost.destroy_all
  end

  after(:each) do
    UserMock.destroy_all
    User.destroy_all
    MicropostMock.destroy_all
    Micropost.destroy_all
  end

 USER_CLASSES = [User, UserMock]


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
      expect(user_mock.attributes).to eq({"id" => nil, "name" => "Dustin Zeisler", "email" => "dustin@example.com", "credits" => nil, "created_at" => nil, "updated_at" => nil, "password_digest" => nil, "remember_token" => true, "admin" => false})
    end

    it 'AR' do
      expect(user_ar.attributes).to eq({"id" => nil, "name" => "Dustin Zeisler", "email" => "dustin@example.com", "credits" => nil, "created_at" => nil, "updated_at" => nil, "password_digest" => nil, "remember_token" => true, "admin" => false})
    end

  end

  describe 'associations' do

    let(:micropost){ Micropost.create(content: 'post')}
    let(:create_attributes){attributes.merge({microposts: [micropost]})}

    let(:user_ar){User.new(create_attributes)}
    let(:user_mock){UserMock.new(create_attributes)}

    it 'the Mock when adding an association will not set the _id attribute, do it manually' do
      expect(user_mock.attributes).to eq({"id" => nil, "name" => "Dustin Zeisler", "email" => "dustin@example.com", "credits" => nil, "created_at" => nil, "updated_at" => nil, "password_digest" => nil, "remember_token" => true, "admin" => false})
      expect(user_mock.microposts).to eq [micropost]
    end

    it 'Ar will not include associations in attributes' do
      expect(user_ar.attributes).to eq({"id" => nil, "name" => "Dustin Zeisler", "email" => "dustin@example.com", "credits" => nil, "created_at" => nil, "updated_at" => nil, "password_digest" => nil, "remember_token" => true, "admin" => false})
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

  describe 'default values' do

      context 'default value of empty string' do

        it "User" do
          user = User.new
          expect(user.email).to eq ""
        end

        it "UserMock" do
          user = UserMock.new
          expect(user.email).to eq ""
        end

      end

      context 'default value of false' do

        it "User" do
          user = User.new
          expect(user.admin).to eq false
          expect(user.remember_token).to eq true
        end

        it "UserMock" do
          user = UserMock.new
          expect(user.admin).to eq false
          expect(user.remember_token).to eq true
        end

      end

      context 'values can be passed' do

        it "User" do
          user = User.new(admin: true, remember_token: false)
          expect(user.admin).to eq true
          expect(user.remember_token).to eq false
        end

        it "UserMock" do
          user = UserMock.new(admin: true, remember_token: false)
          expect(user.admin).to eq true
          expect(user.remember_token).to eq false
        end

      end


  end

  describe 'delete' do

    context 'delete a single record when only one exists' do

      it "User" do
        user = User.create
        user.delete
        expect(User.count).to eq 0
      end

      it "UserMock" do
        user = UserMock.create
        user.delete
        expect(UserMock.count).to eq 0
      end

    end

    context 'deletes the last record when more than one exists' do

      it "User" do
        User.create(email: '1')
        User.create(email: '2')
        user = User.create(email: '3')
        user.delete
        expect(User.count).to eq 2
        User.create(email: '3')
        expect(User.count).to eq 3

      end

      it "UserMock" do
        UserMock.create(email: '1')
        UserMock.create(email: '2')
        user = UserMock.create(email: '3')
        user.delete
        expect(UserMock.count).to eq 2
        UserMock.create(email: '3')
        expect(UserMock.count).to eq 3

      end

    end

    context 'deletes the middle record when more than one exists' do

      it "User" do
        User.create(email: '0')
        user2 =User.create(email: '1')
        user1 = User.create(email: '2')
        User.create(email: '3')
        user1.delete
        user2.delete
        expect(User.count).to eq 2
        User.create(email: '2')
        User.create(email: '4')
        expect(User.count).to eq 4
      end

      it "UserMock" do
        UserMock.create(email: '0')
        user2 =UserMock.create(email: '1')
        user1 = UserMock.create(email: '2')
        UserMock.create(email: '3')
        user1.delete
        user2.delete
        expect(UserMock.count).to eq 2
        UserMock.create(email: '2')
        UserMock.create(email: '4')
        expect(UserMock.count).to eq 4
      end

    end

  end

  describe '::destroy(id)' do

    context 'delete a single record when only one exists' do

      it "User" do
        user = User.create
        User.destroy(user.id)
        expect(User.count).to eq 0
      end

      it "UserMock" do
        user = UserMock.create
        UserMock.destroy(user.id)
        expect(UserMock.count).to eq 0
      end

    end

  end

  describe '::delete_all(conditions = nil)' do

    it "User" do
      user = User.create
      expect(User.delete_all(id: user.id)).to eq 1
      expect(User.count).to eq 0
    end

    it "UserMock" do
      user = UserMock.create
      expect(UserMock.delete_all(id: user.id)).to eq 1
      expect(UserMock.count).to eq 0
    end

  end

  describe '::where(conditions = nil).delete_all', pending: true do
    it "User" do
    pending{ 'new feature implement ActiveMocker::Relation array' }
      user2 = User.create(email: '1')
      user1 = User.create(email: '2')
      expect(User.where(id: user1.id).delete_all).to eq 1
      expect(User.where(id: user1.id).class).to eq User::ActiveRecord_Relation
      expect(User.count).to eq 1
    end

    it "UserMock" do
      pending { 'new feature implement ActiveMocker::Relation array' }
      user2 = UserMock.create(email: '1')
      user1 = UserMock.create(email: '2')
      expect(UserMock.where(id: user1.id).class.name).to eq 'ActiveMocker::Relation'
      expect(UserMock.where(id: user1.id).delete_all).to eq 1
      expect(UserMock.count).to eq 1
    end

  end

end