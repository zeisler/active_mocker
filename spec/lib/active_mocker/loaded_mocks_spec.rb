require 'active_mocker/loaded_mocks'
require 'active_support/core_ext/string'
require 'active_support/core_ext/hash'

describe ActiveMocker::LoadedMocks do

  before(:each) do
    class MockClass

      def self.mocked_class
        'MockClass'
      end

      def self.delete_all
      end

      def self.to_s
        inspect
      end

    end

    class MockClass2 < MockClass

      def self.mocked_class
        'MockClass2'
      end

    end
    ActiveMocker::LoadedMocks
  end

  after(:each) do
    described_class.send(:mocks_store).send(:clear)
  end

  describe '::class_name_to_mock deprecated removed in 2.1' do

    subject { described_class.class_name_to_mock }

    it 'returns key of mocked_class and a constant of the mock class' do
      described_class.send :add, MockClass
      expect(subject.to_hash).to eq({ 'MockClass' => MockClass })
    end

  end

  describe '::all deprecated removed in 2.1' do

    subject { described_class.all }

    it 'returns key of mocked_class and a constant of the mock class' do
      described_class.send :add, MockClass
      expect(subject.to_hash).to eq({ 'MockClass' => MockClass })
    end

  end

  describe '::mocks' do

    subject { described_class.mocks }

    it 'returns key of mocked_class and a constant of the mock class' do
      described_class.send :add, MockClass
      expect(subject.to_hash).to eq({ 'MockClass' => MockClass })
    end

  end

  describe '::delete_all' do

    before do
      described_class.send(:add, MockClass)
      described_class.send(:add, MockClass2)
    end

    it 'will call delete_all on each loaded mock' do
      expect(MockClass).to receive(:delete_all).and_call_original
      expect(MockClass2).to receive(:delete_all).and_call_original
      described_class.delete_all
    end

  end

  describe '::all' do

    it 'returns hash the key being a string and the value being the constant' do
      described_class.send :add, MockClass
      described_class.send :add, MockClass2
      expect(described_class.all.to_h).to eq({ "MockClass" => MockClass, "MockClass2" => MockClass2 })
    end

  end

  describe '::find' do

    before do
      described_class.send :add, MockClass
      described_class.send :add, MockClass2
    end

    it 'returns mocks by string' do
      expect(described_class.find('MockClass2')).to eq MockClass2
    end

    it 'returns mocks by symbol' do
      expect(described_class.find(:MockClass2)).to eq MockClass2
    end

    it 'returns mocks by CONST' do
      expect(described_class.find(MockClass2)).to eq MockClass2
    end

  end

  describe '::all' do

    describe '#except' do

      before do
        described_class.send :add, MockClass
        described_class.send :add, MockClass2
      end

      it 'returns mocks by string' do
        expect(MockClass).to receive(:delete_all)
        described_class.all.except('MockClass2').delete_all
      end

      it 'returns mocks by symbol' do
        expect(MockClass).to receive(:delete_all)
        described_class.all.except(:MockClass2).delete_all
      end

      it 'returns mocks by CONST' do
        expect(MockClass).to receive(:delete_all)
        described_class.all.except(MockClass2).delete_all
      end

    end

    describe '#slice' do

      before do
        described_class.send :add, MockClass
        described_class.send :add, MockClass2
      end

      it 'returns mocks by string' do
        expect(MockClass).to receive(:delete_all)
        described_class.all.slice('MockClass').delete_all
      end

      it 'returns mocks by symbol' do
        expect(MockClass2).to receive(:delete_all)
        described_class.all.slice(:MockClass2).delete_all
      end

      it 'returns mocks by CONST' do
        expect(MockClass2).to receive(:delete_all)
        described_class.all.slice(MockClass2).delete_all
      end

    end

  end

end