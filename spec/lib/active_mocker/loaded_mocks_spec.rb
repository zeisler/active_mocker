require 'active_mocker/db_to_ruby_type'
require 'active_mocker/loaded_mocks'

describe ActiveMocker::LoadedMocks do

  before(:each) do

    class MockClass
      def self.mocked_class
        @@clear_called = false
        @@delete_all_called = false
        @@reload_all_called = false
        'Object'
      end

      def self.clear_mock
        @@clear_called = true
      end

      def self.delete_all
        @@delete_all_called = true
      end

      def self.reload
        @@reload_all_called = true
      end
    end

    class MockClass2
      def self.mocked_class
        @@clear_called = false
        @@delete_all_called = false
        @@reload_all_called = false
        'Object'
      end

      def self.clear_mock
        @@clear_called = true
      end

      def self.delete_all
        @@delete_all_called = true
      end

      def self.reload
        @@reload_all_called = true
      end

    end
  end

  after(:each) do
    described_class.send(:internal_clear)
  end

  describe '::class_name_to_mock' do

    subject{ described_class.class_name_to_mock }

    it 'returns key of mocked_class and a constant of the mock class' do
      described_class.send :add, MockClass
      expect(subject).to eq({'Object' => MockClass})
    end

  end

  describe '::clear_all' do

    before do
      ActiveMocker::LoadedMocks.send(:add, MockClass)
      ActiveMocker::LoadedMocks.send(:add_subclass, MockClass2)
      described_class.clear_all
    end

    it 'will call clear_mock on each loaded mock' do
      expect(clear_mock_called?(MockClass)).to eq true
      expect(clear_mock_called?(MockClass2)).to eq true
    end

    it 'will empty the sub classes' do
      expect(ActiveMocker::LoadedMocks.send(:subclasses).empty?).to eq true
    end

    def clear_mock_called?(mock)
      return true if mock.class_variable_get(:@@clear_called)
      return false
    end

  end

  describe '::delete_all' do

    it 'will call delete_all on each loaded mock' do

      described_class.send(:add, MockClass)
      described_class.send(:add_subclass, MockClass2)
      described_class.delete_all
      expect(delete_all_called?(MockClass)).to eq true
      expect(delete_all_called?(MockClass2)).to eq true

    end

    def delete_all_called?(mock)
      return true if mock.class_variable_get(:@@delete_all_called)
      return false
    end

  end

  describe '::mocks' do

    it 'returns hash the key being a string and the value being the constant' do

      described_class.send :add, MockClass
      described_class.send :add, MockClass2
      expect(described_class.send(:mocks)).to eq({"MockClass" => MockClass, "MockClass2" => MockClass2})

    end

  end

  describe '::all' do

    it 'returns hash the key being a string and the value being the constant' do

      described_class.send :add, MockClass
      described_class.send :add, MockClass2
      expect(described_class.all).to eq({"MockClass" => MockClass, "MockClass2" => MockClass2})

    end

  end

  describe '::undefine_all' do

    # it 'will call delete_all on each loaded mock' do
    #
    #   described_class.add MockClass
    #   described_class.add MockClass2
    #
    #   described_class.undefine_all
    #   expect(Object.const_defined?('MockClass')).to eq false
    #   expect(Object.const_defined?('MockClass2')).to eq false
    #
    # end

  end

  describe '::reload_all' do

    it 'will call reload on each loaded mock' do
      described_class.send :add, MockClass
      described_class.send :add_subclass, MockClass2
      described_class.reload_all
      expect(reload_all_called?(MockClass)).to eq true
      expect(reload_all_called?(MockClass2)).to eq true
    end

    def reload_all_called?(mock)
      return true if mock.class_variable_get(:@@reload_all_called)
      return false
    end

  end

end