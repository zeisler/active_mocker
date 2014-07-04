shared_examples_for 'HasMany' do

  let(:relation_class) {
    class RelationClass
      def initialize(options)
      end
      module Scopes
        def scoped_method
        end
      end
    end
    RelationClass
  }
  describe '::new' do

    let(:collection) { [1, 2] }

    it 'will create an association if no relation class is passed' do
      subject = described_class.new(collection, nil, nil, nil)
      expect(subject.class).to eq ActiveMocker::Mock::Relation
      expect(subject.to_a).to eq collection
    end

    it 'will create self object if has relation class' do
      expect(described_class.new(collection, nil, nil, relation_class)).to be_a_kind_of ActiveMocker::Mock::HasMany
    end

    it 'passes all attributes to super' do
      subject = described_class.new(collection, :key, 1, relation_class)
      expect(subject.to_a).to eq collection
      expect(subject.send(:foreign_key)).to eq(:key)
      expect(subject.send(:foreign_id)).to eq(1)
    end

  end

  describe 'scoped methods' do

    it 'will have scoped methods from relation_class' do
      expect(described_class.new([],nil,nil,relation_class).respond_to?(:scoped_method)).to eq true
    end

  end

  describe '#build' do

    subject { described_class.new([], 'foreign_key', 1, RelationClass) }

    it 'makes a new object from relation_class' do
      allow(RelationClass).to receive(:new)
      subject.build(name: 'Name')
      expect(RelationClass).to have_received(:new).with({'foreign_key' => 1, name: 'Name'})
    end

    context 'with block' do

      before do
        class InstanceWithBlock < RelationClass
          attr_reader :saved
          attr_accessor :name

          def initialize(options, &block)
            yield self if block_given?
          end

          def save
            @saved = true
          end
        end
      end

      subject { described_class.new([], 'foreign_key', 1, InstanceWithBlock) }

      it 'makes a new object with block' do
        instance = subject.build do |i|
          i.name = 'Name'
        end
        instance.save
        expect(instance.name).to eq 'Name'
        expect(subject.first).to eq instance
      end

    end

    it 'returns the new instance' do
      expect(subject.build).to be_kind_of(RelationClass)
    end

    context 'save' do

      before do
        class InstanceSave < RelationClass
          attr_reader :saved

          def initialize(*args)
            @saved = false
          end

          def save
            @saved = true
          end
        end
      end

      subject { described_class.new([], 'foreign_key', 1, InstanceSave) }

      it 'when calling save on the instance it will add it to the collection' do
        new_instance = subject.build
        new_instance.save
        expect(new_instance.saved).to eq true
        expect(subject.to_a).to eq [new_instance]
      end

      let(:second_collection) { described_class.new([], 'foreign_key', 1, relation_class) }

    end

  end

  describe '#create' do

    before do
      allow(RelationClass).to receive(:create) { created_instance}
    end

    let(:created_instance) { double }
    let(:relation_class) { double(create: created_instance, name: 'RelationClass') }

    subject { described_class.new([], 'foreign_key', 1, RelationClass) }

    it 'create a new object from relation_class' do
      subject.create(name: 'Name')
      expect(RelationClass).to have_received(:create).with({'foreign_key' => 1, name: 'Name'})
    end

    it 'will add the created relation to the collection' do
      subject.create
      expect(subject.to_a).to eq ([created_instance])
    end

    it 'returns the created instance' do
      expect(subject.create).to eq (created_instance)
    end

    describe '#create!' do

      it 'will delegate to create' do
        subject.create!
        expect(RelationClass).to have_received(:create)
      end

    end

    context 'with block' do

      subject { described_class.new([], 'foreign_key', 1, InstanceWithBlock) }

      before do
        class InstanceWithBlock
          attr_reader :saved
          attr_accessor :name

          def initialize(options, &block)
            yield self if block_given?
          end

          def save
            @saved = true
          end

          def self.create(options, &block)
            self.new(options, &block)
          end
        end
      end

      let(:relation_class) { InstanceWithBlock }

      it 'makes a new object with block' do
        instance = subject.create do |i|
          i.name = 'Name'
        end
        expect(instance.name).to eq 'Name'
        expect(subject.first).to eq instance
      end

    end

  end
end