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


  let(:attributes) { {name: 'Dustin Zeisler', email: 'dustin@example.com'} }
  let(:attributes_with_admin) { {name: 'Dustin Zeisler', email: 'dustin@example.com', admin: true} }

  describe '::superclass' do

    it 'mock has super of active hash' do
      expect(UserMock.superclass.name).to eq "ActiveMocker::Base"
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

    context 'new with block' do

      def create_with_block(klass)
        user = klass.new do |u|
          u.name = "David"
          u.admin = true
        end

        expect(user.name).to eq 'David'
        expect(user.admin).to eq true

      end

      it 'User' do
        create_with_block(User)
      end

      it 'UserMock' do
        create_with_block(UserMock)
      end

    end

    context 'create with block' do

      def create_with_block(klass)
        user = klass.create do |u|
          u.name = "David"
          u.admin = true
        end

        expect(user.name).to eq 'David'
        expect(user.admin).to eq true

      end

      it 'User' do
        create_with_block(User)
      end

      it 'UserMock' do
        create_with_block(UserMock)
      end

    end

  end

  describe '#attributes' do

    let(:user_ar){User.new(attributes)}
    let(:user_mock){
      UserMock.new(attributes)
    }

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

  describe '::average' do

    def klass_method_average(klass)
      [klass.create!(credits: 12, email: '1'), klass.create!(credits: 2, email: '2'), klass.create!(credits: 8, email: '3'), klass.create!(credits: 4, email: '4')]
      expect(klass.average(:credits).to_s).to eq "6.5"
    end

    it 'User' do
      klass_method_average(User)
    end

    it 'UserMock' do
      klass_method_average(UserMock)
    end

  end

  describe '::minimum' do

    def klass_method_minimum(klass)
      [klass.create!(credits: 12, email: '1'), klass.create!(credits: 2, email: '2'), klass.create!(credits: 8, email: '3'), klass.create!(credits: 4, email: '4')]
      expect(klass.minimum(:credits).to_s).to eq "2.0"
    end

    it 'User' do
      klass_method_minimum(User)
    end

    it 'UserMock' do
      klass_method_minimum(UserMock)
    end

  end

  describe '::maximum' do

    def klass_method_maximum(klass)
      [klass.create!(credits: 12, email: '1'), klass.create!(credits: 2, email: '2'), klass.create!(credits: 8, email: '3'), klass.create!(credits: 4, email: '4')]
      expect(klass.maximum(:credits).to_s).to eq "12.0"
    end

    it 'User' do
      klass_method_maximum(User)
    end

    it 'UserMock' do
      klass_method_maximum(UserMock)
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

    let!(:ar_record){User.create(attributes)}
    let!(:mock_record){UserMock.create(attributes)}
    let!(:mock_record_2){UserMock.create(attributes_with_admin)}

    it 'AR' do
      expect([ar_record]).to eq User.where(attributes)
    end

    it 'Mock' do
      expect(UserMock.where(attributes)).to eq [mock_record, mock_record_2]
    end

    it 'Mock will not take sql string needs to be mocked' do
      UserMock.create(attributes_with_admin)
      expect{UserMock.where("name = 'Dustin Zeisler'")}.to raise_error
    end

    context 'by association not only attribute'do

      def where_by_association(user_class, micropost_class)
        user = user_class.create!(email: '1')
        micropost = micropost_class.create(user: user)
        expect(micropost_class.where(user: user)).to eq [micropost]
      end

      it 'User' do
        where_by_association(User, Micropost)
      end

      it 'UserMock' do
        where_by_association(UserMock, MicropostMock)
      end

    end

    context 'passing array as value' do

      def array_as_value(user_class)
        users = [user_class.create!(email: '1', name: 'Alice'), user_class.create!(email: '2', name: 'Bob')]
        expect(user_class.where({name: ["Alice", "Bob"]})).to eq(users)
      end

      it 'User' do
        array_as_value(User)
      end

      it 'UserMock' do
        array_as_value(UserMock)
      end

    end

    context 'will return all if no options passed' do

      def where_no_options(klass, where_klass)
        records = [klass.create!(email: '1', name: 'fred'), klass.create!(email: '2', name: 'fred'), klass.create!(email: '3', name: 'Sam')]
        expect(klass.where.class).to eq(where_klass)
      end

      it 'User' do
        where_no_options(User, ActiveRecord::QueryMethods::WhereChain)
      end

      it 'UserMock' do
        where_no_options(UserMock, ActiveMocker::Queries::WhereNotChain)
      end

    end

    context 'multiple wheres' do

      def where_where(klass)
        records = [klass.create!(email: '1', name: 'fred', admin: true), klass.create!(email: '2', name: 'fred'), klass.create!(email: '3', name: 'Sam')]
        expect(klass.where(name: 'fred').where(admin: true)).to eq([records[0]])
      end

      it 'User' do
        where_where(User)
      end

      it 'UserMock' do
        where_where(UserMock)
      end

    end

  end

  describe '::where.not' do

    def where_not(klass)
      records = [klass.create!(email: '1', name: 'fred'), klass.create!(email: '2', name: 'fred'), klass.create!(email: '3', name: 'Sam')]
      expect(klass.where.not(name: 'fred')).to eq([records[2]])
    end

    it 'User' do
      where_not(User)
    end

    it 'UserMock' do
      where_not(UserMock)
    end

  end

  describe '::update_all' do

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

    let(:support_array_methods) { [:<<, :take, :push, :clear, :first, :last, :concat, :replace, :distinct, :uniq, :count, :size, :length, :empty?, :any?, :include?] }

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
        supported_array_methods(UserMock, MicropostMock, ActiveMocker::HasMany)
      end

    end

    describe '#find' do

      context 'single id passed' do

        def collection_find(user_class, micropost, collection_klass)
          microposts = [micropost.create, micropost.create]
          user = user_class.create!(email: '1', name: 'fred', microposts: microposts)
          expect(user.microposts.find(microposts.first.id)).to eq microposts.first
        end

        it 'User' do
          collection_find(User, Micropost, Micropost::ActiveRecord_Associations_CollectionProxy)
        end

        it 'UserMock' do
          collection_find(UserMock, MicropostMock, ActiveMocker::Association)
        end

      end

      context 'multiple ids passed' do

        def collection_finds(user_class, micropost, collection_klass)
          microposts = [micropost.create(id: 1), micropost.create(id: 2)]
          user = user_class.create!(email: '1', name: 'fred', microposts: microposts)
          expect(user.microposts.find([microposts.first.id, microposts.last.id])).to include *microposts.first, microposts.last
        end

        it 'User' do
          collection_finds(User, Micropost, Micropost::ActiveRecord_Associations_CollectionProxy)
        end

        it 'UserMock' do
          collection_finds(UserMock, MicropostMock, ActiveMocker::Association)
        end

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

    context 'can delete unsaved object from collection' do

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

  describe 'Collections'do

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

  describe  '::limit' do

    def klass_limit(klass)
      records = [klass.create!(email: '1', name: 'fred'), klass.create!(email: '2', name: 'Dan'), klass.create!(email: '3', name: 'Sam')]
      expect(klass.limit(2)).to eq [records[0], records[1]]
      expect(klass.limit(2).where(name: 'fred')).to eq [records[0]]
    end

    it 'User' do
      klass_limit(User)
    end

    it 'UserMock' do
      klass_limit(UserMock)
    end

  end

  describe '::find_by!' do

    context 'will raise exception if not found' do

      def find_by_exception(user_class, error)
        expect{user_class.find_by!(name: 'Matz')}.to raise_error(error)
      end

      it 'User' do
        find_by_exception(User, ActiveRecord::RecordNotFound)
      end

      it 'UserMock' do
        find_by_exception(UserMock, ActiveMocker::RecordNotFound)
      end

    end

    context 'will find one record by conditions' do

      def find_by_one_result(user_class)
        user = user_class.create!(email: '1', name: 'fred')
        expect(user_class.find_by!(name: 'fred') ).to eq user
      end

      it 'User' do
        find_by_one_result(User)
      end

      it 'UserMock' do
        find_by_one_result(UserMock)
      end

    end

  end

  describe '::transaction' do

    context 'will run code in block' do

      def transaction(user_class)
        user_class.transaction do
          user_class.create(email: '1')
          user_class.create(email: '2')
        end

        expect(user_class.count).to eq 2
      end

      it 'User' do
        transaction(User)
      end

      it 'UserMock' do
        transaction(UserMock)
      end

    end

  end

  describe 'belongs_to association' do

    describe 'when setting association by object it will set id if object is persisted' do

      def id_set_by_object(post_class, user_class)
        user = user_class.create
        post = post_class.create(user: user)
        expect(post.user_id).to eq user.id
      end

      it 'User' do
        id_set_by_object(Micropost, User)
      end

      it 'UserMock' do
        id_set_by_object(MicropostMock, UserMock)
      end

    end

    describe 'when setting association by id it will set the object on the parent' do

      def object_set_by_id(post_class, user_class)
        user = user_class.create
        post = post_class.create(user_id: user.id)
        expect(post.user).to eq user
      end

      it 'User' do
        object_set_by_id(Micropost, User)
      end

      it 'UserMock' do
        object_set_by_id(MicropostMock, UserMock)
      end

    end

    describe 'when setting association by object it will not set id if object is not persisted' do

      def id_set_by_object(post_class, user_class)
        user = user_class.new
        post = post_class.new(user: user)
        expect(post.user_id).to eq nil
      end

      it 'User' do
        id_set_by_object(Micropost, User)
      end

      it 'UserMock' do
        id_set_by_object(MicropostMock, UserMock)
      end

    end

  end

  describe 'has_many association' do

    describe 'when passing in collection all item in collection will set its foreign key to the parent' do

      def id_set_to_children(user_class, post_class)
        posts = [post_class.create, post_class.create, post_class.create]
        user = user_class.create(microposts: posts)
        expect(user.microposts.map(&:user_id)).to eq posts.map(&:user_id)
        expect(posts.map(&:user_id)).to eq [user.id, user.id, user.id]
      end

      it 'User' do
        id_set_to_children(User, Micropost)
      end

      it 'UserMock' do
        id_set_to_children(UserMock, MicropostMock)
      end

    end

  end

  describe 'can build new object from collection' do

    def new_record_on_collection(user_class, post_class)
      user = user_class.create
      new_post = user.microposts.build
      expect(new_post.class).to eq(post_class)
      expect(new_post.attributes).to eq({"id" => nil, "content" => nil, "user_id" => 1, "up_votes" => nil, "created_at" => nil, "updated_at" => nil})
      expect(user.microposts.count).to eq 0
      new_post.save
      expect(user.microposts.count).to eq(1)
      expect(user.microposts.first).to eq(new_post)
    end

    it 'User' do
      new_record_on_collection(User, Micropost)
    end

    it 'UserMock' do
      new_record_on_collection(UserMock, MicropostMock)
    end

  end

  describe 'can create new object from collection' do

    def create_record_on_collection(user_class, post_class)
      user = user_class.create
      new_post = user.microposts.create
      expect(new_post.class).to eq(post_class)
      expect(new_post.user_id).to eq(1)
      expect(user.microposts.count).to eq 1
      expect(user.microposts.first).to eq(new_post)
    end

    it 'User' do
      create_record_on_collection(User, Micropost)
    end

    it 'UserMock' do
      create_record_on_collection(UserMock, MicropostMock)
    end

  end

end