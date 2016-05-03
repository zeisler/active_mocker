# frozen_string_literal: true
shared_examples_for "ActiveRecord" do |micropost_class, account_class|
  let(:user_class) { described_class }

  before do
    micropost_class.delete_all
    user_class.delete_all
    account_class.delete_all
  end

  let(:attributes) { { name: "Dustin Zeisler", email: "dustin@example.com" } }
  let(:attributes_with_admin) { { name: "Dustin Zeisler", email: "dustin@example.com", admin: true } }

  describe "instance only methods" do
    describe '#attribute_names' do
      it "Returns an array of names for the attributes available on this object" do
        expect(user_class.new.attribute_names).to eq %w(id name email credits created_at updated_at password_digest remember_token admin)
      end
    end

    describe '#attribute_present?' do
      it "Returns true if the specified +attribute+ has been set and is neither nil nor empty?" do
        expect(user_class.new(name: "Dustin").attribute_present?(:name)).to eq true
        expect(user_class.new.attribute_present?(:name)).to eq false
      end
    end

    describe '#has_attribute?' do
      it "Returns true if the specified +attribute+ has been set and is neither nil nor empty?" do
        expect(user_class.new.has_attribute?(:name)).to eq true
        expect(user_class.new.has_attribute?(:last_name)).to eq false
      end
    end

    describe '#persisted?' do
      it "Indicates if the model is persisted" do
        expect(user_class.create.persisted?).to eq true
        expect(user_class.new.persisted?).to eq false
      end
    end

    describe '#new_record?' do
      it "Indicates if the model is persisted" do
        expect(user_class.new.new_record?).to eq true
        expect(user_class.create.new_record?).to eq false
      end
    end

    describe '#freeze' do
      it "will freeze the attributes hash" do
        record = user_class.create(name: "Dustin")
        record.freeze
        expect { record.name = "Justin" }.to raise_error(RuntimeError, /[c|C]an't modify frozen/)
      end
    end
  end

  describe "::create" do
    let(:create_attributes) { attributes }

    it "id with a strings values" do
      expect(user_class.create(id: "a").id).to eq 0
    end

    it "mock will take all attributes that AR takes" do
      user_class.create(create_attributes)
    end

    it "new with block" do
      user = user_class.new do |u|
        u.name  = "David"
        u.admin = true
      end

      expect(user.name).to eq "David"
      expect(user.admin).to eq true
    end

    it "create with block" do
      user = user_class.create do |u|
        u.name  = "David"
        u.admin = true
      end

      expect(user.name).to eq "David"
      expect(user.admin).to eq true
    end
  end

  describe "::update" do
    it "Updates one record" do
      user = user_class.create
      user_class.update(user.id, name: "Samuel")
      expect(user_class.find(user.id).name).to eq "Samuel"
    end

    it "Updates multiple records" do
      users  = [user_class.create!(email: "1"),
                user_class.create!(email: "2")]
      people = { users.first.id => { "name" => "David" }, users.last.id => { "name" => "Jeremy" } }
      user_class.update(people.keys, people.values)
      expect(user_class.all.map(&:name)).to eq %w(David Jeremy)
    end
  end

  it '#attributes' do
    expect(user_class.new(attributes).attributes).to eq("id" => nil, "name" => "Dustin Zeisler", "email" => "dustin@example.com", "credits" => nil, "created_at" => nil, "updated_at" => nil, "password_digest" => nil, "remember_token" => true, "admin" => false)
  end

  describe "associations" do
    let(:micropost) { micropost_class.create(content: "post") }
    let(:create_attributes) { attributes.merge(microposts: [micropost]) }

    let(:user) { user_class.new(create_attributes) }

    it "the Mock when adding an association will not set the _id attribute, do it manually" do
      expect(user.attributes).to eq("id" => nil, "name" => "Dustin Zeisler", "email" => "dustin@example.com", "credits" => nil, "created_at" => nil, "updated_at" => nil, "password_digest" => nil, "remember_token" => true, "admin" => false)
      expect(user.microposts).to eq [micropost]
    end
  end

  it "::column_names" do
    expect(user_class.column_names).to eq(%w(id name email credits created_at updated_at password_digest remember_token admin))
  end

  it "::attribute_names" do
    expect(user_class.attribute_names).to eq(%w(id name email credits created_at updated_at password_digest remember_token admin))
  end

  it "::all" do
    array = [user_class.create!(email: "1", name: "fred"),
             user_class.create!(email: "2", name: "fred"),
             user_class.create!(email: "3", name: "Sam")]
    expect(user_class.all).to eq array
  end

  it "::average" do
    [user_class.create!(credits: 12, email: "1"),
     user_class.create!(credits: 2, email: "2"),
     user_class.create!(credits: 8, email: "3"),
     user_class.create!(credits: 4, email: "4")]
    expect(user_class.average(:credits).to_s).to eq "6.5"
  end

  it "::minimum" do
    [user_class.create!(credits: 12, email: "1"),
     user_class.create!(credits: 2, email: "2"),
     user_class.create!(credits: 8, email: "3"),
     user_class.create!(credits: 4, email: "4")]
    expect(user_class.minimum(:credits).to_s).to eq "2.0"
  end

  it "::maximum" do
    [user_class.create!(credits: 12, email: "1"),
     user_class.create!(credits: 2, email: "2"),
     user_class.create!(credits: 8, email: "3"),
     user_class.create!(credits: 4, email: "4")]
    expect(user_class.maximum(:credits).to_s).to eq "12.0"
  end

  describe "::count" do
    it "the total count of all records" do
      [user_class.create!(credits: 12, email: "1"),
       user_class.create!(credits: 2, email: "2"),
       user_class.create!(credits: 8, email: "3"),
       user_class.create!(credits: 4, email: "4")]
      expect(user_class.count).to eq 4
    end

    it "returns the total count of all records where the attribute is present in database" do
      [user_class.create!(credits: 12, email: "1"),
       user_class.create!(credits: 2, email: "2"),
       user_class.create!(credits: 8, email: "3"),
       user_class.create!(credits: nil, email: "4")]
      expect(user_class.count(:credits)).to eq 3
    end
  end

  it "::find_by" do
    expect(user_class.create(attributes)).to eq user_class.find_by(attributes)
  end

  describe "::where" do
    let(:record) { user_class.create(attributes) }

    it { expect([record]).to eq user_class.where(attributes) }

    it "by association not only attribute" do
      user      = user_class.create!(email: "1")
      micropost = micropost_class.create(user: user)
      expect(micropost_class.where(user: user)).to eq [micropost]
    end

    it "passing array as value" do
      users = [user_class.create!(email: "1", name: "Alice"),
               user_class.create!(email: "2", name: "Bob")]
      expect(user_class.where(name: %w(Alice Bob))).to eq(users)
    end

    it "multiple wheres" do
      records = [user_class.create!(email: "1", name: "fred", admin: true),
                 user_class.create!(email: "2", name: "fred"),
                 user_class.create!(email: "3", name: "Sam")]
      expect(user_class.where(name: "fred").where(admin: true)).to eq([records[0]])
    end

    context "with range value" do
      let!(:given_record) { micropost_class.create(up_votes: 9) }

      it { expect(micropost_class.where(up_votes: 0..10)).to eq [given_record] }
    end
  end

  it "::where.not" do
    records = [user_class.create!(email: "1", name: "fred"),
               user_class.create!(email: "2", name: "fred"),
               user_class.create!(email: "3", name: "Sam")]
    expect(user_class.where.not(name: "fred")).to eq([records[2]])
  end

  it "::update_all" do
    [user_class.create!(email: "1", name: "fred"),
     user_class.create!(email: "2", name: "fred"),
     user_class.create!(email: "3", name: "Sam")]
    user_class.update_all(name: "John")
    expect(user_class.all.map(&:name)).to eq(%w(John John John))
  end

  describe "::update" do
    it "Updates one record" do
      user = user_class.create(email: "90")
      user_class.update(user.id, email: "Samuel", name: "Name")
      user.reload
      expect(user.email).to eq "Samuel"
      expect(user.name).to eq "Name"
    end

    it "Updates multiple records" do
      user_records = [user_class.create(email: "1"), user_class.create(email: "2")]
      users        = { user_records.first.id => { name: "Fred" }, user_records.last.id => { name: "Dave" } }
      user_class.update(users.keys, users.values)
      user_records.map(&:reload)
      expect(user_records.map(&:name)).to eq %w(Fred Dave)
    end
  end

  describe "::slice" do
    it "removes out wanted attributes and returns a hash" do
      expect(user_class.create(email: "2", name: "Fred").slice(:email, :name)).to eq("email" => "2", "name" => "Fred")
    end
  end

  describe "type coercion" do
    it "will coerce string to integer" do
      expect(micropost_class.new(user_id: "1").user_id).to eq 1
    end

    it "will coerce string to bool" do
      expect(user_class.new(admin: "true").admin).to eq true
    end

    it "will coerce string to decimal" do
      expect(user_class.new(credits: "12345").credits).to eq 12_345.0
    end

    it "will coerce string to datetime" do
      expect(user_class.new(created_at: "1/1/1990").created_at).to eq "Mon, 01 Jan 1990 00:00:00 UTC +00:00"
    end

    it "will coerce integer to string" do
      expect(user_class.create(name: 1).reload.name).to eq "1"
    end
  end

  describe "CollectionAssociation" do
    let(:support_array_methods) { [:<<, :take, :push, :clear, :first, :last, :concat, :replace, :distinct, :uniq, :count, :size, :length, :empty?, :any?, :include?] }

    it "supported array methods" do
      mp1  = micropost_class.create!(content: "text")
      mp2  = micropost_class.create!(content: "text")
      user = user_class.create(microposts: [mp1, mp2])
      expect(user.microposts.take(1).count).to eq(1)
      expect(user.microposts.methods).to include *support_array_methods
    end

    describe '#none' do
      it "will be equal to an empty array" do
        expect(micropost_class.none).to eq []
      end

      context "can call query methods" do
        it "where" do
          expect(user_class.none.where(name: "No one")).to eq []
        end

        it "count" do
          expect(user_class.none.count).to eq 0
        end
      end

      it "can call scoped methods" do
        expect(user_class.none.respond_to?(:find_by_name)).to eq true
      end
    end
  end

  describe '#find' do
    it "single id passed" do
      microposts = [micropost_class.create, micropost_class.create]
      user       = user_class.create!(email: "1", name: "fred", microposts: microposts)
      expect(user.microposts.find(microposts.first.id)).to eq microposts.first
    end

    it "single string id passed" do
      microposts = [micropost_class.create, micropost_class.create]
      user       = user_class.create!(email: "1", name: "fred", microposts: microposts)
      expect(user.microposts.find(microposts.first.id.to_s)).to eq microposts.first
    end

    it "multiple ids passed" do
      microposts = [micropost_class.create(id: 1), micropost_class.create(id: 2)]
      user       = user_class.create!(email: "1", name: "fred", microposts: microposts)
      expect(user.microposts.find([microposts.first.id, microposts.last.id])).to include *microposts.first, microposts.last
    end

    it "multiple string ids passed" do
      microposts = [micropost_class.create(id: 1), micropost_class.create(id: 2)]
      user       = user_class.create!(email: "1", name: "fred", microposts: microposts)
      expect(user.microposts.find([microposts.first.id.to_s, microposts.last.id.to_s])).to include *microposts.first, microposts.last
    end

    it "will raise an error if not found from id" do
      expect { micropost_class.find(104) }.to raise_error(/Couldn't find Micropost(Mock)? with 'id'=104/)
    end

    it "will raise an error if argument is nil" do
      expect { user_class.find(nil) }.to raise_error(/Couldn't find User(Mock)? with.*id/i)
    end
  end

  it '#sum' do
    mpm1      = micropost_class.create!(up_votes: 5)
    mpm2      = micropost_class.create!(up_votes: 5)
    user_mock = user_class.create!(microposts: [mpm1, mpm2])
    expect(user_mock.microposts.sum(:up_votes)).to eq 10
  end

  it "can delete unsaved object from collection" do
    mp1  = micropost_class.create!(content: "text")
    mp2  = micropost_class.create!(content: "text")
    user = user_class.new(microposts: [mp1, mp2])
    user.microposts.delete(mp1)
  end

  describe "Collections" do
    context "delete_all" do
      it "deletes all records from result" do
        [user_class.create!(email: "1", name: "fred"),
         user_class.create!(email: "2", name: "fred"),
         user_class.create!(email: "3", name: "Sam")]
        user_class.where(name: "fred").delete_all
        expect(user_class.count).to eq 1
      end

      it "deletes all records association" do
        user = user_class.create!(email:      "1", name: "fred",
                                  microposts: [micropost_class.create, micropost_class.create])
        user.microposts.delete_all
        expect(user_class.count).to eq 1
      end

      it "If a limit scope is supplied, +delete_all+ raises an ActiveMocker error:" do
        expect { user_class.limit(100).delete_all }.to raise_error(/delete_all doesn't support limit/)
      end
    end

    context "where" do
      it "all.where" do
        records = [user_class.create!(email: "1", name: "fred"),
                   user_class.create!(email: "2", name: "fred"),
                   user_class.create!(email: "3", name: "Sam")]
        expect(user_class.all.where(name: "fred")).to eq([records[0], records[1]])
      end

      context "order" do
        it "where.order" do
          records = [user_class.create!(email: "2", name: "fred"),
                     user_class.create!(email: "1", name: "fred"),
                     user_class.create!(email: "3", name: "Sam")]
          expect(user_class.where(name: "fred").order(:email)).to eq([records[1], records[0]])
        end

        it "where.order.reverse_order" do
          records = [user_class.create!(email: "2", name: "fred"),
                     user_class.create!(email: "1", name: "fred"),
                     user_class.create!(email: "3", name: "Sam")]
          expect(user_class.where(name: "fred").order(:email).reverse_order).to eq([records[0], records[1]])
        end
      end
    end
  end

  context "update_all" do
    it "where.update_all" do
      [user_class.create!(email: "1", name: "fred"), user_class.create!(email: "2", name: "fred"), user_class.create!(email: "3", name: "Sam")]
      user_class.where(name: "fred").update_all(name: "John")
      expect(user_class.all.map(&:name)).to eq(%w(John John Sam))
    end

    it "all.update_all" do
      [user_class.create!(email: "1", name: "fred"), user_class.create!(email: "2", name: "fred"), user_class.create!(email: "3", name: "Sam")]
      user_class.all.update_all(name: "John")
      expect(user_class.all.map(&:name)).to eq(%w(John John John))
    end
  end

  describe "default values" do
    it "default value of empty string" do
      user = user_class.new
      expect(user.email).to eq ""
    end

    it "default value of false" do
      user = user_class.new
      expect(user.admin).to eq false
      expect(user.remember_token).to eq true
    end

    it "values can be passed" do
      user = user_class.new(admin: true, remember_token: false)
      expect(user.admin).to eq true
      expect(user.remember_token).to eq false
    end
  end

  describe "delete" do
    it "delete a single record when only one exists" do
      user = user_class.create
      user.delete
      expect(user_class.count).to eq 0
    end

    it "deletes the last record when more than one exists" do
      user_class.create(email: "1")
      user_class.create(email: "2")
      user = user_class.create(email: "3")
      user.delete
      expect(user_class.count).to eq 2
      user_class.create(email: "3")
      expect(user_class.count).to eq 3
    end

    it "deletes the middle record when more than one exists" do
      user_class.create(email: "0")
      user2 = user_class.create(email: "1")
      user1 = user_class.create(email: "2")
      user_class.create(email: "3")
      user1.delete
      user2.delete
      expect(user_class.count).to eq 2
      user_class.create(email: "2")
      user_class.create(email: "4")
      expect(user_class.count).to eq 4
    end
  end

  describe "::delete(id)" do
    it "delete a single record when only one exists" do
      user = user_class.create
      user_class.delete(user.id)
      expect(user_class.count).to eq 0
    end

    it "will delete all by array of ids" do
      ids = [micropost_class.create.id, micropost_class.create.id, micropost_class.create.id]
      micropost_class.delete(ids)
      expect(micropost_class.count).to eq 0
    end
  end

  it "::delete_all(conditions = nil)" do
    user = user_class.create
    expect(user_class.delete_all(id: user.id)).to eq 1
    expect(user_class.count).to eq 0
  end

  it "::limit" do
    records = [user_class.create!(email: "1", name: "fred"), user_class.create!(email: "2", name: "Dan"), user_class.create!(email: "3", name: "Sam")]
    expect(user_class.limit(2)).to eq [records[0], records[1]]
    expect(user_class.limit(2).where(name: "fred")).to eq [records[0]]
  end

  context "limit(10).delete_all" do
    it "If a limit scope is supplied, delete_all raises an ActiveRecord error:" do
      expect { user_class.limit(10).delete_all }.to raise_error(/delete_all doesn't support limit/)
    end
  end

  describe "::find_by!" do
    it "will raise exception if not found" do
      expect { user_class.find_by!(name: "Matz") }.to raise_error(/Couldn't find User/)
    end

    it "will find one record by conditions" do
      user = user_class.create!(email: "1", name: "fred")
      expect(user_class.find_by!(name: "fred")).to eq user
    end

    it "will raise error if no record found" do
      expect { user_class.find_by!(name: "noFound") }.to raise_error(/Couldn't find User/)
    end
  end

  describe "::transaction" do
    it "will run code in block" do
      user_class.transaction do
        user_class.create(email: "1")
        user_class.create(email: "2")
      end

      expect(user_class.count).to eq 2
    end
  end

  describe "belongs_to association" do
    it "will also set the foreign key " do
      user = user_class.create
      post = micropost_class.create(user: user)
      expect(post.user_id).to eq user.id
    end

    it "will persist the association and set the foreign key" do
      user = user_class.new
      post = micropost_class.create(user: user)
      expect(post.user_id).to eq user.id
      expect(user.reload.persisted?).to eq true
    end

    it "when setting association by object it will set the child association" do
      user = user_class.create
      post = micropost_class.create(user: user)
      expect(user.microposts).to eq [post]
    end

    it "when setting association by id it will set the object on the parent" do
      user = user_class.create
      post = micropost_class.create(user_id: user.id)
      expect(post.user).to eq user
    end

    it "when setting association by object it will not set id if object is not persisted" do
      user = user_class.new
      post = micropost_class.new(user: user)
      expect(post.user_id).to eq nil
    end

    it "can build" do
      post = micropost_class.new
      user = post.build_user
      expect(user.class).to eq user_class
      expect(post.user).to eq user
    end
  end

  describe "has one association" do
    it "account" do
      account = account_class.new
      user    = user_class.new(account: account)
      expect(user.account).to eq account
    end

    it "account.user will be a user if not persisted" do
      account = account_class.new
      user    = user_class.new(account: account)
      expect(account.user).to eq user
    end

    it "account.user will be a user if is persisted" do
      account = account_class.create
      user    = user_class.new(account: account)
      expect(account.user).to eq user
    end
  end

  describe "has_many association" do
    it "when passing in collection all item in collection will set its foreign key to the parent" do
      posts = [micropost_class.create, micropost_class.create, micropost_class.create]
      user  = user_class.create(microposts: posts)
      expect(user.microposts.map(&:user_id)).to eq posts.map(&:user_id)
      expect(posts.map(&:user_id)).to eq [user.id, user.id, user.id]
    end
  end

  it "can build new object from collection" do
    user     = user_class.create
    new_post = user.microposts.build
    expect(new_post.class).to eq(micropost_class)
    expect(new_post.attributes).to eq("id" => nil, "content" => nil, "user_id" => 1, "up_votes" => nil, "created_at" => nil, "updated_at" => nil)
    expect(user.microposts.count).to eq 0
    new_post.save
    expect(user.microposts.count).to eq(1)
    expect(user.microposts.first).to eq(new_post)
  end

  it "can create new object from collection" do
    user     = user_class.create
    new_post = user.microposts.create
    expect(new_post.class).to eq(micropost_class)
    expect(new_post.user_id).to eq(1)
    expect(user.microposts.count).to eq 1
    expect(user.microposts.first).to eq(new_post)
  end

  describe "named scopes" do
    it "can call a scope method from all" do
      expect(user_class.all.respond_to?(:by_name)).to eq true
    end

    it "can call a scope method from where" do
      expect(user_class.where(credit: 1).respond_to?(:by_name)).to eq true
    end

    it "can call a scope method from all.where" do
      expect(user_class.all.where(credit: 1).respond_to?(:by_name)).to eq true
    end
  end

  describe "creating a record with an id higher than 1 and then create a record with id 1" do
    it do
      micropost_class.create!(id: 3)
      micropost_class.create!("id" => 1)
      expect(micropost_class.create!.id).to eq 4
    end
  end

  describe "table_name" do
    it "returns the table name for the model" do
      expect(user_class.table_name).to eq "users"
    end
  end

  describe "all[]" do
    let!(:sample_records) do
      [micropost_class.create(id: 4),
       micropost_class.create(id: 5)]
    end

    # Order that comes back from ActiveRecord is database dependant and may not always return in the same order
    it "get a record at an index" do
      expect(micropost_class.all[1].class).to eq micropost_class
    end

    it "get a range of records at an index" do
      expect(micropost_class.all[0..1]).to include *sample_records
    end
  end

  describe ".alias_attribute" do
    it "aliases an attribute" do
      user = user_class.new(name: "My Name")
      expect(user.first_and_last_name).to eq "My Name"
      expect(user.name).to eq "My Name"
    end

    it "can be initialized with an aliased attribute" do
      user = user_class.new(first_and_last_name: "My Name")
      expect(user.first_and_last_name).to eq "My Name"
      expect(user.name).to eq "My Name"
    end
  end

  describe ".attribute_alias?" do

    it "returns true when given a aliased attribute" do
      expect(user_class.attribute_alias?(:first_and_last_name)).to eq true
    end

    it "returns false when given a non aliased attribute" do
      expect(user_class.attribute_alias?(:name)).to eq false
    end
  end

  describe ".attribute_aliases" do
    it "return a hash of the new attribute name mapped to the old attribute name" do
      expect(user_class.attribute_aliases).to eq({"first_and_last_name"=>"name"})
    end
  end
end
