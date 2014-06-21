require 'rspec'
$:.unshift File.expand_path('../../', __FILE__)
require 'active_support/all'
require 'active_mock/queries'
require 'active_mock/collection'
require 'ostruct'

describe ActiveMock::Queries do

  before do

    class Queriable < ActiveMock::Collection
      include ActiveMock::Queries
    end

  end

  subject{ Queriable.new }

  describe '#sum' do

    it 'sum values by attribute name' do
      subject << [OpenStruct.new(value: 1), OpenStruct.new(value: 1)]
      expect(subject.sum(:value)).to eq 2
    end

  end

  describe '#limit' do

    let!(:given_collection){ [OpenStruct.new(value: 1),
                              OpenStruct.new(value: 2),
                              OpenStruct.new(value: 3)]}

    it 'will return only the n-number of items' do
      subject << given_collection
      expect(subject.limit(1).count).to eq 1
    end

  end

  describe '#<<' do

    it 'will add a single item to the array' do

      subject << "item"
      expect(subject.count).to eq 1
      expect(subject.first).to eq 'item'

    end

    it 'will add a many item to the array' do

      subject << ['item1', 'item2', 'item3']
      expect(subject.count).to eq 3
      expect(subject).to eq ['item1', 'item2', 'item3']

    end

  end

  describe 'new' do

    it 'take optional item and adds to collection' do

      subject = Queriable.new(1)

      expect(subject.first).to eq 1

    end

    it 'can take an array' do

      subject = Queriable.new([1])

      expect(subject.first).to eq 1

      subject = Queriable.new([1,2])

      expect(subject.last).to eq 2

    end

  end

  describe 'empty?' do

    it 'returns true if collection is empty' do
      expect(subject.empty?).to eq true
    end

    it 'returns false if collection is not empty' do
      subject << 1
      expect(subject.empty?).to eq false
    end

  end

  describe 'each' do

    it 'can iterate over array' do
      sum = 0
      Queriable.new([1, 2]).each { |a| sum += a }
      expect(sum).to eq 3
    end

  end

  describe 'map' do

    it 'return a new array' do
      expect(Queriable.new([1, 2]).map { |a| a + a }).to eq [2, 4]
    end

    it 'return an instance of the class' do
      expect(Queriable.new([1, 2]).map { |a| a + a }).to be_a_kind_of Array
    end

  end

  describe 'delete_all' do

    let!(:given_collection) { [double(delete: true),
                               double(delete: true),
                               double(delete: true)] }

    before do
      given_collection.each do |item|
        expect(item).to receive(:delete)
      end
      subject << given_collection
    end

    it 'calls delete on every item in the collection' do
      subject.delete_all
    end

    context 'alias destroy_all' do

      it 'calls delete on every item in the collection' do
        subject.destroy_all
      end

    end

  end

  describe '#all' do
    subject{ Queriable.new(given_collection)}

    let(:given_collection) { [1,1,1] }

    it 'return the collection' do
      expect(subject.all).to eq given_collection
    end

    it 'returns an instance of the class' do
      expect(subject.all).to be_a_kind_of Queriable
    end

  end

  describe 'where' do

    context 'with condition' do

      subject{ Queriable.new(given_collection)}

      let(:given_collection) { [OpenStruct.new(value: 1),
                                 OpenStruct.new(value: 2),
                                 OpenStruct.new(value: 3)] }

      it 'returns array of values that meet the condition' do
        expect(subject.where(value: 1)).to eq [given_collection.first]
      end

      it 'returns an instance of the class' do
        expect(subject.where(value: 1)).to be_a_kind_of(Queriable)
      end

    end

    context 'without condition' do

      subject { Queriable.new(given_collection) }

      it 'return a WhereNotChain' do
        expect(subject.where).to be_a_kind_of(ActiveMock::Queries::WhereNotChain)
      end

      let(:given_collection) { [OpenStruct.new(value: 1),
                                OpenStruct.new(value: 2),
                                OpenStruct.new(value: 3)] }

      it 'takes .not(condition)' do
        expect(subject.where.not(value: 1)).to eq [given_collection[1], given_collection[2]]
      end

      it '.not(condition) return the class' do
        expect(subject.where.not(value: 1)).to be_a_kind_of(Queriable)
      end

    end

  end

end