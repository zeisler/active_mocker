shared_examples_for 'ActiveRecord' do

  let(:attributes) { {name: 'Dustin Zeisler', email: 'dustin@example.com'} }
  let(:attributes_with_admin) { {name: 'Dustin Zeisler', email: 'dustin@example.com', admin: true} }

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
end