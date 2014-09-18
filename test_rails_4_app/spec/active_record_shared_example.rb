shared_examples_for 'ActiveRecord' do |micropost_class|

  before do
    micropost_class.delete_all
    described_class.delete_all
  end

  let(:attributes) { {name: 'Dustin Zeisler', email: 'dustin@example.com'} }
  let(:attributes_with_admin) { {name: 'Dustin Zeisler', email: 'dustin@example.com', admin: true} }

  describe 'instance only methods' do

    describe '#attribute_names' do

      it 'Returns an array of names for the attributes available on this object' do
        expect(described_class.new.attribute_names).to eq ["id", "name", "email", "credits", "created_at", "updated_at", "password_digest", "remember_token", "admin"]
      end

    end

    describe '#attribute_present?' do

      it 'Returns true if the specified +attribute+ has been set and is neither nil nor empty?' do
        expect(described_class.new(name: 'Dustin').attribute_present?(:name)).to eq true
        expect(described_class.new.attribute_present?(:name)).to eq false
      end

    end

    describe '#has_attribute?' do

      it 'Returns true if the specified +attribute+ has been set and is neither nil nor empty?' do
        expect(described_class.new.has_attribute?(:name)).to eq true
        expect(described_class.new.has_attribute?(:last_name)).to eq false
      end

    end

    describe '#persisted?' do

      it 'Indicates if the model is persisted' do
        expect(described_class.create.persisted?).to eq true
        expect(described_class.new.persisted?).to eq false
      end

    end

    describe '#new_record?' do

      it 'Indicates if the model is persisted' do
        expect(described_class.new.new_record?).to eq true
        expect(described_class.create.new_record?).to eq false
      end

    end

  end

  describe '::create' do

    let(:create_attributes) { attributes }

    it 'mock will take all attributes that AR takes' do
      described_class.create(create_attributes)
    end

    it 'new with block' do
      user = described_class.new do |u|
        u.name  = "David"
        u.admin = true
      end

      expect(user.name).to eq 'David'
      expect(user.admin).to eq true
    end

    it 'create with block' do
      user = described_class.create do |u|
        u.name = "David"
        u.admin = true
      end

      expect(user.name).to eq 'David'
      expect(user.admin).to eq true
    end

  end

  describe '::update' do

    it 'Updates one record' do
      user = described_class.create
      described_class.update(user.id, name: 'Samuel')
      expect(described_class.find(user.id).name).to eq 'Samuel'
    end

    it 'Updates multiple records' do
      users = [described_class.create!(email: '1'),
                described_class.create!(email: '2')]
      people = {users.first.id => {"name" => "David"}, users.last.id => {"name" => "Jeremy"}}
      described_class.update(people.keys, people.values)
      expect(described_class.all.map(&:name)).to eq ["David", "Jeremy"]
    end

  end

  it '#attributes' do
    expect(described_class.new(attributes).attributes).to eq({"id" => nil, "name" => "Dustin Zeisler", "email" => "dustin@example.com", "credits" => nil, "created_at" => nil, "updated_at" => nil, "password_digest" => nil, "remember_token" => true, "admin" => false})
  end

  describe 'associations' do

    let(:micropost) { micropost_class.create(content: 'post') }
    let(:create_attributes) { attributes.merge({microposts: [micropost]}) }

    let(:user) { described_class.new(create_attributes) }

    it 'the Mock when adding an association will not set the _id attribute, do it manually' do
      expect(user.attributes).to eq({"id" => nil, "name" => "Dustin Zeisler", "email" => "dustin@example.com", "credits" => nil, "created_at" => nil, "updated_at" => nil, "password_digest" => nil, "remember_token" => true, "admin" => false})
      expect(user.microposts).to eq [micropost]
    end

  end

  it '::column_names' do
    expect(described_class.column_names).to eq(["id", "name", "email", "credits", "created_at", "updated_at", "password_digest", "remember_token", "admin"])
  end

  it '::attribute_names' do
    expect(described_class.attribute_names).to eq(["id", "name", "email", "credits", "created_at", "updated_at", "password_digest", "remember_token", "admin"])
  end

  it '::all' do
    array = [described_class.create!(email: '1', name: 'fred'),
             described_class.create!(email: '2', name: 'fred'),
             described_class.create!(email: '3', name: 'Sam')]
    expect(described_class.all).to eq array
  end

  it '::average' do
    [described_class.create!(credits: 12, email: '1'),
     described_class.create!(credits: 2, email: '2'),
     described_class.create!(credits: 8, email: '3'),
     described_class.create!(credits: 4, email: '4')]
    expect(described_class.average(:credits).to_s).to eq "6.5"
  end

  it '::minimum' do
    [described_class.create!(credits: 12, email: '1'),
     described_class.create!(credits: 2, email: '2'),
     described_class.create!(credits: 8, email: '3'),
     described_class.create!(credits: 4, email: '4')]
    expect(described_class.minimum(:credits).to_s).to eq "2.0"
  end

  it '::maximum' do
    [described_class.create!(credits: 12, email: '1'),
     described_class.create!(credits: 2, email: '2'),
     described_class.create!(credits: 8, email: '3'),
     described_class.create!(credits: 4, email: '4')]
    expect(described_class.maximum(:credits).to_s).to eq "12.0"
  end

  describe '::count' do

    it 'the total count of all records' do
      [described_class.create!(credits: 12, email: '1'),
       described_class.create!(credits: 2, email: '2'),
       described_class.create!(credits: 8, email: '3'),
       described_class.create!(credits: 4, email: '4')]
      expect(described_class.count).to eq 4

    end

    it 'returns the total count of all records where the attribute is present in database' do
      [described_class.create!(credits: 12, email: '1'),
       described_class.create!(credits: 2, email: '2'),
       described_class.create!(credits: 8, email: '3'),
       described_class.create!(credits: nil, email: '4')]
      expect(described_class.count(:credits)).to eq 3
    end

  end

  it '::find_by' do
    expect(described_class.create(attributes)).to eq described_class.find_by(attributes)
  end

  describe '::where' do

    let(:record) { described_class.create(attributes) }

    it { expect([record]).to eq described_class.where(attributes) }

    it 'by association not only attribute' do
      user = described_class.create!(email: '1')
      micropost = micropost_class.create(user: user)
      expect(micropost_class.where(user: user)).to eq [micropost]
    end

    it 'passing array as value' do
      users = [described_class.create!(email: '1', name: 'Alice'),
               described_class.create!(email: '2', name: 'Bob')]
      expect(described_class.where({name: ["Alice", "Bob"]})).to eq(users)
    end

    it 'multiple wheres' do
        records = [described_class.create!(email: '1', name: 'fred', admin: true),
                   described_class.create!(email: '2', name: 'fred'),
                   described_class.create!(email: '3', name: 'Sam')]
        expect(described_class.where(name: 'fred').where(admin: true)).to eq([records[0]])
    end

    context 'with range value' do

      let!(:given_record) { micropost_class.create(up_votes: 9) }

      it { expect(micropost_class.where(up_votes: 0..10)).to eq [given_record] }

    end

  end

  it '::where.not' do
      records = [described_class.create!(email: '1', name: 'fred'),
                 described_class.create!(email: '2', name: 'fred'),
                 described_class.create!(email: '3', name: 'Sam')]
      expect(described_class.where.not(name: 'fred')).to eq([records[2]])
  end

  it '::update_all' do
    [described_class.create!(email: '1', name: 'fred'),
     described_class.create!(email: '2', name: 'fred'),
     described_class.create!(email: '3', name: 'Sam')]
    described_class.update_all(name: 'John')
    expect(described_class.all.map { |a| a.name }).to eq(['John', 'John', 'John'])
  end

  describe '::update' do

    it 'Updates one record' do
      user = described_class.create(email: '90')
      described_class.update(user.id, email: 'Samuel', name: 'Name')
      user.reload
      expect(user.email).to eq 'Samuel'
      expect(user.name).to eq 'Name'
    end

    it 'Updates multiple records' do
      user_records = [described_class.create(email: '1'), described_class.create(email: '2')]
      users = {user_records.first.id => {name: 'Fred'}, user_records.last.id => { name: 'Dave'}}
      described_class.update(users.keys, users.values)
      user_records.map(&:reload)
      expect(user_records.map(&:name)).to eq ['Fred', 'Dave']
    end

  end

  describe 'type coercion' do

    it 'will coerce string to integer' do
      expect(micropost_class.new(user_id: '1').user_id).to eq 1
    end

    it 'will coerce string to bool' do
      expect(described_class.new(admin: 'true').admin).to eq true
    end

    it 'will coerce string to decimal' do
      expect(described_class.new(credits: '12345').credits).to eq 12345.0
    end

    it 'will coerce string to datetime' do
      expect(described_class.new(created_at: '1/1/1990').created_at).to eq 'Mon, 01 Jan 1990 00:00:00 UTC +00:00'
    end

    it 'will coerce integer to string' do
      expect(described_class.create(name: 1).reload.name).to eq '1'
    end

  end

  describe 'CollectionAssociation' do

    let(:support_array_methods) { [:<<, :take, :push, :clear, :first, :last, :concat, :replace, :distinct, :uniq, :count, :size, :length, :empty?, :any?, :include?] }

    it 'supported array methods' do
        mp1 = micropost_class.create!(content: 'text')
        mp2 = micropost_class.create!(content: 'text')
        user = described_class.create(microposts: [mp1, mp2])
        expect(user.microposts.take(1).count).to eq(1)
        expect(user.microposts.methods).to include *support_array_methods
    end

  end

  describe '#find' do

    it 'single id passed' do
      microposts = [micropost_class.create, micropost_class.create]
      user = described_class.create!(email: '1', name: 'fred', microposts: microposts)
      expect(user.microposts.find(microposts.first.id)).to eq microposts.first
    end

    it 'multiple ids passed' do
      microposts = [micropost_class.create(id: 1), micropost_class.create(id: 2)]
      user = described_class.create!(email: '1', name: 'fred', microposts: microposts)
      expect(user.microposts.find([microposts.first.id, microposts.last.id])).to include *microposts.first, microposts.last
    end

  end

  it '#sum' do
    mpm1 = micropost_class.create!(up_votes: 5)
    mpm2 = micropost_class.create!(up_votes: 5)
    user_mock = described_class.create!(microposts: [mpm1, mpm2])
    expect(user_mock.microposts.sum(:up_votes)).to eq 10
  end

  it 'can delete unsaved object from collection' do
    mp1  = micropost_class.create!(content: 'text')
    mp2  = micropost_class.create!(content: 'text')
    user = described_class.new(microposts: [mp1, mp2])
    user.microposts.delete(mp1)
  end

  describe 'Collections' do

    context 'delete_all' do

      it 'deletes all records from result' do
        [described_class.create!(email: '1', name: 'fred'),
         described_class.create!(email: '2', name: 'fred'),
         described_class.create!(email: '3', name: 'Sam')]
        described_class.where(name: 'fred').delete_all
        expect(described_class.count).to eq 1
      end

      it 'deletes all records association' do
          user = described_class.create!(email: '1', name: 'fred',
                                         microposts: [micropost_class.create, micropost_class.create])
          user.microposts.delete_all
          expect(described_class.count).to eq 1
      end

      it 'If a limit scope is supplied, +delete_all+ raises an ActiveMocker error:' do
        expect{described_class.limit(100).delete_all}.to raise_error("delete_all doesn't support limit scope")
      end

    end

    context 'where' do

      it 'all.where' do
        records = [described_class.create!(email: '1', name: 'fred'),
                   described_class.create!(email: '2', name: 'fred'),
                   described_class.create!(email: '3', name: 'Sam')]
        expect(described_class.all.where(name: 'fred')).to eq([records[0], records[1]])
      end

      context 'order' do

        it 'where.order' do

          records = [described_class.create!(email: '2', name: 'fred'),
                     described_class.create!(email: '1', name: 'fred'),
                     described_class.create!(email: '3', name: 'Sam')]
          expect(described_class.where(name: 'fred').order(:email)).to eq([records[1], records[0]])
        end

        it 'where.order.reverse_order' do

            records = [described_class.create!(email: '2', name: 'fred'),
                       described_class.create!(email: '1', name: 'fred'),
                       described_class.create!(email: '3', name: 'Sam')]
            expect(described_class.where(name: 'fred').order(:email).reverse_order).to eq([records[0], records[1]])

        end

      end

    end

  end

  context 'update_all' do

    it 'where.update_all' do
      [described_class.create!(email: '1', name: 'fred'), described_class.create!(email: '2', name: 'fred'), described_class.create!(email: '3', name: 'Sam')]
      described_class.where(name: 'fred').update_all(name: 'John')
      expect(described_class.all.map { |a| a.name }).to eq(['John', 'John', 'Sam'])
    end

    it 'all.update_all' do
      [described_class.create!(email: '1', name: 'fred'), described_class.create!(email: '2', name: 'fred'), described_class.create!(email: '3', name: 'Sam')]
      described_class.all.update_all(name: 'John')
      expect(described_class.all.map { |a| a.name }).to eq(['John', 'John', 'John'])
    end

  end

  describe 'default values' do

    it 'default value of empty string' do
      user = described_class.new
      expect(user.email).to eq ""
    end

    it 'default value of false' do
      user = described_class.new
      expect(user.admin).to eq false
      expect(user.remember_token).to eq true
    end

    it 'values can be passed' do
      user = described_class.new(admin: true, remember_token: false)
      expect(user.admin).to eq true
      expect(user.remember_token).to eq false
    end

  end

  describe 'delete' do

    it 'delete a single record when only one exists' do
      user = described_class.create
      user.delete
      expect(described_class.count).to eq 0
    end

    it 'deletes the last record when more than one exists' do
      described_class.create(email: '1')
      described_class.create(email: '2')
      user = described_class.create(email: '3')
      user.delete
      expect(described_class.count).to eq 2
      described_class.create(email: '3')
      expect(described_class.count).to eq 3
    end

    it 'deletes the middle record when more than one exists' do
      described_class.create(email: '0')
      user2 = described_class.create(email: '1')
      user1 = described_class.create(email: '2')
      described_class.create(email: '3')
      user1.delete
      user2.delete
      expect(described_class.count).to eq 2
      described_class.create(email: '2')
      described_class.create(email: '4')
      expect(described_class.count).to eq 4
    end

  end

  describe '::delete(id)' do

    it 'delete a single record when only one exists' do
      user = described_class.create
      described_class.delete(user.id)
      expect(described_class.count).to eq 0
    end

    it 'will delete all by array of ids' do
      ids = [micropost_class.create.id, micropost_class.create.id, micropost_class.create.id]
      micropost_class.delete(ids)
      expect(micropost_class.count).to eq 0
    end

  end

  it '::delete_all(conditions = nil)' do
    user = described_class.create
    expect(described_class.delete_all(id: user.id)).to eq 1
    expect(described_class.count).to eq 0
  end

  it '::limit' do
    records = [described_class.create!(email: '1', name: 'fred'), described_class.create!(email: '2', name: 'Dan'), described_class.create!(email: '3', name: 'Sam')]
    expect(described_class.limit(2)).to eq [records[0], records[1]]
    expect(described_class.limit(2).where(name: 'fred')).to eq [records[0]]
  end

  context 'limit(10).delete_all' do

    it "If a limit scope is supplied, delete_all raises an ActiveRecord error:" do
      expect{described_class.limit(10).delete_all}.to raise_error("delete_all doesn't support limit scope")
    end

  end

  describe '::find_by!' do

    it 'will raise exception if not found' do
      expect { described_class.find_by!(name: 'Matz') }.to raise_error
    end

    it 'will find one record by conditions' do
      user = described_class.create!(email: '1', name: 'fred')
      expect(described_class.find_by!(name: 'fred')).to eq user
    end

  end

  describe '::transaction' do

    it 'will run code in block' do

      described_class.transaction do
        described_class.create(email: '1')
        described_class.create(email: '2')
      end

      expect(described_class.count).to eq 2

    end

  end

  describe 'belongs_to association' do

    it 'when setting association by object it will set id if object is persisted' do
      user = described_class.create
      post = micropost_class.create(user: user)
      expect(post.user_id).to eq user.id
    end

    describe 'experimental features' do

      before do
        ActiveMocker::Mock.config.experimental = true
      end

      it 'when setting association by object it will set the child association' do
        user = described_class.create
        post = micropost_class.create(user: user)
        expect(user.microposts).to eq [post]
      end

    end

    it 'when setting association by id it will set the object on the parent' do
      user = described_class.create
      post = micropost_class.create(user_id: user.id)
      expect(post.user).to eq user
    end

    it 'when setting association by object it will not set id if object is not persisted' do
      user = described_class.new
      post = micropost_class.new(user: user)
      expect(post.user_id).to eq nil
    end

    it 'can build' do
      post = micropost_class.new
      user = post.build_user
      expect(user.class).to eq described_class
      expect(post.user).to eq user
    end

  end

  describe 'has_many association' do

    before do
      ActiveMocker::Mock.config.experimental = true
    end

    it 'when passing in collection all item in collection will set its foreign key to the parent' do
      posts = [micropost_class.create, micropost_class.create, micropost_class.create]
      user = described_class.create(microposts: posts)
      expect(user.microposts.map(&:user_id)).to eq posts.map(&:user_id)
      expect(posts.map(&:user_id)).to eq [user.id, user.id, user.id]
    end

  end

  it 'can build new object from collection' do
    user = described_class.create
    new_post = user.microposts.build
    expect(new_post.class).to eq(micropost_class)
    expect(new_post.attributes).to eq({"id" => nil, "content" => nil, "user_id" => 1, "up_votes" => nil, "created_at" => nil, "updated_at" => nil})
    expect(user.microposts.count).to eq 0
    new_post.save
    expect(user.microposts.count).to eq(1)
    expect(user.microposts.first).to eq(new_post)
  end

  it 'can create new object from collection' do
    user = described_class.create
    new_post = user.microposts.create
    expect(new_post.class).to eq(micropost_class)
    expect(new_post.user_id).to eq(1)
    expect(user.microposts.count).to eq 1
    expect(user.microposts.first).to eq(new_post)
  end

  describe 'named scopes' do

    it 'can call a scope method from all' do
      expect(described_class.all.respond_to?(:by_name)).to eq true
    end

    it 'can call a scope method from where' do
      expect(described_class.where(credit: 1).respond_to?(:by_name)).to eq true
    end

    it 'can call a scope method from all.where' do
      expect(described_class.all.where(credit: 1).respond_to?(:by_name)).to eq true
    end
    
  end

  describe 'creating a record with an id higher than 1 and then create a record with id 1' do

    it do
      micropost_class.create!(id: 3)
      micropost_class.create!('id' => 1)
      expect(micropost_class.create!.id).to eq 4
    end

  end

end