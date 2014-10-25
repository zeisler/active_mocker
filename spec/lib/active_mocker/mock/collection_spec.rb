require 'spec_helper'
require 'active_mocker/mock/collection'

describe ActiveMocker::Mock::Collection do

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
      described_class.new([1, 2]).each { |a| sum += a }
      expect(sum).to eq 3
    end

  end

  describe 'map' do

    it 'return a new array' do
      expect(described_class.new([1, 2]).map { |a| a + a }).to eq [2, 4]
    end

    it 'return an instance of the class' do
      expect(described_class.new([1, 2]).map { |a| a + a }).to be_a_kind_of Array
    end

  end

  describe '[]' do

    it 'can get an item from the array' do
      expect(described_class.new([1, 2])[0]).to eq 1
    end

    it 'can get a range of items from the array' do
      expect(described_class.new([1, 2])[0..1]).to eq [1, 2]
    end

  end

end