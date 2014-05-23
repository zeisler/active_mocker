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

  describe '::all' do

    def klass_all(klass)
      array = [klass.create!(email: '1', name: 'fred'), klass.create!(email: '2', name: 'fred'), klass.create!(email: '3', name: 'Sam')]
      expect(klass.all).to eq array
    end

    it 'User' do
      klass_all(User)
    end

    it 'UserMock' do
      klass_all(UserMock)
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

  describe 'attribute_names' do

    it 'they are the same' do
      expect(UserMock.attribute_names).to eq User.attribute_names
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

  describe '::update_all', pending: true do

    def klass_update_all(klass)
      [klass.create!(email: '1', name: 'fred'), klass.create!(email: '2', name: 'fred'), klass.create!(email: '3', name: 'Sam')]
      klass.update_all(name: 'John')
      expect(klass.all.map{|a| a.name}).to eq(['John', 'John', 'John'])
    end

    it 'User' do
      klass_update_all(User)
    end

    it 'UserMock' do
      klass_update_all(UserMock)
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

    let(:support_array_methods) { [:<<, :take, :push, :clear, :first, :last, :concat, :replace, :distinct, :uniq, :count, :size, :length, :empty?, :any?, :include?, :includes] }

    context 'supported array methods' do

      def supported_array_methods(user_class, micropost, collection_klass)
        mp1 = micropost.create!(content: 'text')
        mp2 = micropost.create!(content: 'text')
        user = user_class.create(microposts: [mp1, mp2])
        expect(user.microposts.take(1).count).to eq(1)
        expect(user.microposts.class).to eq(collection_klass)
        expect(user.microposts.methods).to include *support_array_methods
      end

      it 'User' do
        supported_array_methods(User, Micropost, Micropost::ActiveRecord_Associations_CollectionProxy)
      end

      it 'UserMock' do
        supported_array_methods(UserMock, MicropostMock, ActiveMocker::Collection::Association)
      end


    end

    describe '#sum' do

      def collection_association_sum(user_class, micropost)
        mpm1 = micropost.create!(up_votes: 5)
        mpm2 = micropost.create!(up_votes: 5)
        user_mock = user_class.create!(microposts: [mpm1, mpm2])
        expect(user_mock.microposts.sum(:up_votes)).to eq 10
      end

      it 'User' do
        collection_association_sum(User, Micropost)
      end

      it 'UserMock' do
        collection_association_sum(UserMock, MicropostMock)
      end


    end



    context 'can delete unsaved object from collection', pending:true do

      def delete_object(klasses)
        mp1 = klasses.first.create!(content: 'text')
        mp2 = klasses.first.create!(content: 'text')
        user = klasses.last.new(microposts: [mp1, mp2])
        user.microposts.delete(mp1)
        expect(user.microposts).to eq [mp2]
      end

      it 'UserMock' do
        delete_object([MicropostMock, UserMock])
      end

      it 'User' do
        delete_object([Micropost, User])
      end

    end

  end

  describe 'Collections', pending: true do

    context 'delete_all' do

      context 'deletes all records from result' do

        def collections_delete_all(klass)
          [klass.create!(email: '1', name: 'fred'), klass.create!(email: '2', name: 'fred'), klass.create!(email: '3', name: 'Sam')]
          klass.where(name: 'fred').delete_all
          expect(klass.count).to eq 1
        end

        it 'User' do
          collections_delete_all(User)
        end

        it 'UserMock' do
          collections_delete_all(UserMock)
        end

      end

      context 'deletes all records association' do

        def association_collections_delete_all(user_class, micropost)
          user = user_class.create!(email: '1', name: 'fred', microposts: [micropost.create, micropost.create])
          user.microposts.delete_all
          expect(user_class.count).to eq 1
        end

        it 'User' do
          association_collections_delete_all(User, Micropost)
        end

        it 'UserMock' do
          association_collections_delete_all(UserMock, MicropostMock)
        end

      end

    end

    context 'where' do

      context 'all.where' do

        def collections_all_where(klass)
          records = [klass.create!(email: '1', name: 'fred'), klass.create!(email: '2', name: 'fred'), klass.create!(email: '3', name: 'Sam')]
          expect(klass.all.where(name: 'fred')).to eq([records[0], records[1]])
        end

        it 'User' do
          collections_all_where(User)
        end

        it 'UserMock' do
          collections_all_where(UserMock)
        end

      end

      context 'where.where' do

        def collections_where_where(klass)
          records = [klass.create!(email: '1', name: 'fred'), klass.create!(email: '2', name: 'fred'), klass.create!(email: '3', name: 'Sam')]
          expect(klass.where(email: '1').where(name: 'fred')).to eq([records[0]])
        end

        it 'User' do
          collections_where_where(User)
        end

        it 'UserMock' do
          collections_where_where(UserMock)
        end

      end

    end

    context 'order' do

      context 'where.order' do

        def collections_where_order(klass)
          records = [klass.create!(email: '2', name: 'fred'), klass.create!(email: '1', name: 'fred'), klass.create!(email: '3', name: 'Sam')]
          expect(klass.where(name: 'fred').order(:email)).to eq([records[1], records[0]])
        end

        it 'User' do
          collections_where_order(User)
        end

        it 'UserMock' do
          collections_where_order(UserMock)
        end

      end

      context 'where.order.reverse_order' do

        def collections_where_order_reverse_order(klass)
          records = [klass.create!(email: '2', name: 'fred'), klass.create!(email: '1', name: 'fred'), klass.create!(email: '3', name: 'Sam')]
          expect(klass.where(name: 'fred').order(:email).reverse_order).to eq([records[0], records[1]])
        end

        it 'User' do
          collections_where_order_reverse_order(User)
        end

        it 'UserMock' do
          collections_where_order_reverse_order(UserMock)
        end

      end

    end

    context 'update_all' do

      context 'where.update_all' do

        def collection_where_update_all(klass)
          [klass.create!(email: '1', name: 'fred'), klass.create!(email: '2', name: 'fred'), klass.create!(email: '3', name: 'Sam')]
          klass.where(name: 'fred' ).update_all(name: 'John')
          expect(klass.all.map { |a| a.name }).to eq(['John', 'John', 'Sam'])
        end

        it 'User' do
          collection_where_update_all(User)
        end

        it 'UserMock' do
          collection_where_update_all(UserMock)
        end

      end

      context 'all.update_all' do

        def collection_all_update_all(klass)
          [klass.create!(email: '1', name: 'fred'), klass.create!(email: '2', name: 'fred'), klass.create!(email: '3', name: 'Sam')]
          klass.all.update_all(name: 'John')
          expect(klass.all.map { |a| a.name }).to eq(['John', 'John', 'John'])
        end

        it 'User' do
          collection_all_update_all(User)
        end

        it 'UserMock' do
          collection_all_update_all(UserMock)
        end

      end

    end

    #User.all.average("orders_count")
    #User.all.minimum("age")
    #User.all.maximum("age")


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

end