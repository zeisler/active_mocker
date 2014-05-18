require 'rspec'
$:.unshift File.expand_path('../../', __FILE__)
require 'active_support/all'
require 'active_mocker/collection_association'
require 'ostruct'

describe ActiveMocker::CollectionAssociation do

  subject{described_class.new}

  describe '#sum' do


    it 'sum values by attribute name' do

      subject << [OpenStruct.new(value: 1), OpenStruct.new(value: 1)]
      expect(subject.sum(:value)).to eq 2

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

      subject = described_class.new(1)

      expect(subject.first).to eq 1

    end

    it 'can take an array' do

      subject = described_class.new([1])

      expect(subject.first).to eq 1

      subject = described_class.new([1,2])

      expect(subject.last).to eq 2

    end

  end

  describe 'empty?' do

    it 'works' do

      expect(subject.empty?).to eq true

    end

  end

  describe 'each' do

    it 'works' do
      expect(described_class.new([1,2]).each{|a| a + a}).to eq [1, 2]

    end

  end

  describe 'map' do

    it 'works' do
      expect(described_class.new([1, 2]).map { |a| a + a }).to eq [2, 4]
    end

  end


end