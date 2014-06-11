require 'rspec'
$:.unshift File.expand_path('../../', __FILE__)
require 'active_mocker/loaded_mocks'

describe ActiveMocker::LoadedMocks do

  around do

    class MockClass
      def self.mocked_class
        'Object'
      end
    end

    class MockClass2
      def self.mocked_class
        'Object'
      end
    end
  end

  describe '::class_name_to_mock' do

    subject{ described_class.class_name_to_mock }

    it 'returns key of mocked_class and a constant of the mock class' do
      described_class.add MockClass
      expect(subject).to eq({'Object' => MockClass})
    end

  end

  describe '::clear_all' do

    it 'will call clear_mock on each loaded mock' do

      described_class.add MockClass
      described_class.add MockClass2
      expect(MockClass).to receive(:clear_mock)
      expect(MockClass2).to receive(:clear_mock)
      described_class.clear_all

    end

  end

  describe '::delete_all' do

    it 'will call delete_all on each loaded mock' do

      described_class.add MockClass
      described_class.add MockClass2
      expect(MockClass).to receive(:delete_all)
      expect(MockClass2).to receive(:delete_all)
      described_class.delete_all

    end

  end

  describe '::reload_all' do

    it 'will call delete_all on each loaded mock' do

      described_class.add MockClass
      described_class.add MockClass2
      expect(MockClass).to receive(:reload)
      expect(MockClass2).to receive(:reload)
      described_class.reload_all

    end

  end

  describe '::mocks' do

    it 'returns hash the key being a string and the value being the constant' do

      described_class.add MockClass
      described_class.add MockClass2
      expect(described_class.mocks).to eq({"MockClass" => MockClass, "MockClass2" => MockClass2})

    end

  end

  describe '::all' do

    it 'returns hash the key being a string and the value being the constant' do

      described_class.add MockClass
      described_class.add MockClass2
      expect(described_class.all).to eq({"MockClass" => MockClass, "MockClass2" => MockClass2})

    end

  end

  describe '::undefine_all' do

    it 'will call delete_all on each loaded mock' do

      described_class.add MockClass
      described_class.add MockClass2

      described_class.undefine_all
      expect(Object.const_defined?('MockClass')).to eq false
      expect(Object.const_defined?('MockClass2')).to eq false

    end

  end

end