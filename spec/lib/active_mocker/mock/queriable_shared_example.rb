# frozen_string_literal: true
shared_examples_for "Queriable" do |klass|
  subject do
    new_class.call
  end

  let(:new_class) { -> (*args) { klass.call(args) } }

  describe '#sum' do
    it "sum values by attribute name" do
      query = new_class.call(OpenStruct.new(value: 1), OpenStruct.new(value: 1), OpenStruct.new(value: 2))
      expect(query.sum(:value)).to eq 4
    end

    it "if attribute is nil will default zero" do
      query = new_class.call(OpenStruct.new(value: nil), OpenStruct.new(value: 1))
      expect(query.sum(:value)).to eq 1
    end

    it "if attribute is zero" do
      query = new_class.call(OpenStruct.new(value: 0))
      expect(query.sum(:value)).to eq 0
    end
  end

  describe '#limit' do
    let!(:given_collection) do
      [OpenStruct.new(value: 1),
       OpenStruct.new(value: 2),
       OpenStruct.new(value: 3)]
    end

    it "will return only the n-number of items" do
      expect(new_class.call(given_collection).limit(1).count).to eq 1
    end
  end

  describe "new" do
    it "take optional item and adds to collection" do
      subject = new_class.call(1)

      expect(subject.first).to eq 1
    end

    it "can take an array" do
      subject = new_class.call([1])

      expect(subject.first).to eq 1

      subject = new_class.call([1, 2])

      expect(subject.last).to eq 2
    end
  end

  describe "delete_all" do
    let(:given_collection) do
      [double(delete: true),
       double(delete: true),
       double(delete: true)]
    end

    it "calls delete on every item in the collection" do
      query = new_class.call(given_collection)
      query.delete_all
      expect(query.count).to eq 0
    end

    context "alias destroy_all" do
      it "calls delete on every item in the collection" do
        new_class.call(given_collection).destroy_all
      end
    end
  end

  describe '#all' do
    subject { new_class.call(given_collection) }

    let(:given_collection) { [1, 1, 1] }

    it "return the collection" do
      expect(subject.all).to eq given_collection
    end

    it "returns an instance of the class" do
      expect(subject.all).to be_a_kind_of ActiveMocker::Relation
    end
  end

  describe "where" do
    context "with condition" do
      subject { new_class.call(given_collection) }

      let(:given_collection) do
        [OpenStruct.new(value: 1),
         OpenStruct.new(value: 2),
         OpenStruct.new(value: 3)]
      end

      it "returns array of values that meet the condition" do
        expect(subject.where(value: 1)).to eq [given_collection.first]
      end

      it "returns an instance of the class" do
        expect(subject.where(value: 1)).to be_a_kind_of(ActiveMocker::Relation)
      end
    end

    context "without condition" do
      subject { new_class.call(given_collection) }

      it "return a WhereNotChain" do
        expect(subject.where).to be_a_kind_of(ActiveMocker::Queries::WhereNotChain)
      end

      let(:given_collection) do
        [OpenStruct.new(value: 1),
         OpenStruct.new(value: 2),
         OpenStruct.new(value: 3)]
      end

      it "takes .not(condition)" do
        expect(subject.where.not(value: 1)).to eq [given_collection[1], given_collection[2]]
      end

      it ".not(condition) return the class" do
        expect(subject.where.not(value: 1)).to be_a_kind_of(ActiveMocker::Relation)
      end
    end
  end

  describe '#none' do
    it "will be equal to an empty array" do
      expect(subject.none).to eq []
    end

    context "can call query methods" do
      it "where" do
        expect(subject.none.where(value: 90_000)).to eq []
      end

      it "count" do
        expect(subject.none.count).to eq 0
      end
    end
  end
end
