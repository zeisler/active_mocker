require 'active_mocker/db_to_ruby_type'
require 'active_mocker/loaded_mocks'
require 'active_support/core_ext/string'
require 'active_support/core_ext/hash'

describe ActiveMocker::LoadedMocks do

  before(:each) do
    ActiveMocker::LoadedMocks.disable_global_state = true
    class MockClass

      def self.mocked_class
        'MockClass'
      end

      def self.clear_mock
      end

      def self.delete_all
      end

      def self.reload
      end

      def self.inspect
        if self.respond_to? :_uniq_key_for_record_context
          "#{mocked_class}#{_uniq_key_for_record_context.camelcase}"
        else
          super
        end
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
  end

  after(:each) do
    described_class.send(:internal_clear)
  end

  describe '::class_name_to_mock' do

    subject { described_class.class_name_to_mock }

    it 'returns key of mocked_class and a constant of the mock class' do
      described_class.send :add, MockClass
      expect(subject.to_hash).to eq({ 'MockClass' => MockClass })
    end

  end

  xdescribe '::clear_all' do

    before do
      described_class.send(:add, MockClass)
      described_class.send(:add_subclass, MockClass2)
    end

    it 'will call clear_mock on each loaded mock' do
      expect(MockClass).to receive(:clear_mock)
      expect(MockClass2).to receive(:clear_mock)
      described_class.clear_all
    end

    it 'will empty the sub classes' do
      described_class.clear_all
      expect(ActiveMocker::LoadedMocks.send(:subclasses).empty?).to eq true
    end

    it 'will call clear_mock on scoped_set' do
      described_class.scoped_set('ab3a9z').mocks.each do |mock|
        expect(mock).to receive(:clear_mock)
      end
      described_class.clear_all
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

    it 'will call delete_all on scoped_set' do
      described_class.scoped_set('ab3aarsta2').mocks.each do |mock|
        expect(mock).to receive(:delete_all)
      end
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

  describe '::scoped_set' do

    it 'Given a unique hash key it creates a unique set of mocks from the mocks that are loaded' do
      described_class.send :add, MockClass
      described_class.send :add, MockClass2
      expect(described_class.scoped_set('ab3a9z').to_h.transform_values(&:to_s)).to eq({ "MockClass" => "MockClassAb3a9z", "MockClass2" => "MockClass2Ab3a9z" })
      expect(described_class.scoped_set('ab3a9z').to_h).to eq({
                                                                  "MockClass"  => described_class.scoped_set('ab3a9z').find(:MockClass),
                                                                  "MockClass2" => described_class.scoped_set('ab3a9z').find(:MockClass2)
                                                              })
    end

    it 'will return default set if key is nil' do
      described_class.send :add, MockClass
      described_class.send :add, MockClass2
      expect(described_class.scoped_set(nil).to_h).to eq({ "MockClass" => MockClass, "MockClass2" => MockClass2 })
    end

    describe 'Returned Object' do

      subject { described_class.scoped_set('ast90asTQ') }

      before do
        described_class.send :add, MockClass
        described_class.send :add, MockClass2
        subject
      end

      after do
        described_class.deallocate_scoped_set('ast90asTQ')
      end

      describe '#except.delete_all' do

        it 'takes symbol of the original model name' do
          expect(subject.slice(MockClass2).mocks.first).to receive(:delete_all)
          expect(MockClass2).to_not receive(:delete_all)
          expect(subject.slice(MockClass).mocks.first).to_not receive(:delete_all)
          subject.except(:MockClass).delete_all
        end

        it 'takes the original class' do
          expect(subject.slice(MockClass2).mocks.first).to receive(:delete_all)
          expect(MockClass2).to_not receive(:delete_all)
          expect(subject.slice(MockClass).mocks.first).to_not receive(:delete_all)
          subject.except(MockClass).delete_all
        end

        it 'takes the scoped mock class' do
          expect(MockClass2).to receive(:delete_all)
          expect(MockClass).to_not receive(:delete_all)
          subject.except(subject.slice(MockClass).mocks.first).delete_all
        end

      end

      it '#delete_all' do
        expect(MockClass2).to receive(:delete_all)
        expect(MockClass).to receive(:delete_all)
        subject.delete_all
      end

      describe '#find' do

        it 'takes symbol of the original model name and returns the mock class' do
          expect(subject.find(:MockClass)).to eq(subject.slice(MockClass).mocks.first)
        end

        it 'takes the original class and returns the mock class' do
          expect(subject.find(MockClass)).to eq(subject.slice(MockClass).mocks.first)
        end

        it 'takes the scoped mock class and returns the mock class' do
          expect(subject.find(subject.slice(MockClass2).mocks.first)).to eq(subject.slice(MockClass2).mocks.first)
        end

        it 'with a blank scope' do
          expect(described_class.scoped_set(nil).find(:MockClass)).to eq MockClass
        end

      end

    end

  end

end