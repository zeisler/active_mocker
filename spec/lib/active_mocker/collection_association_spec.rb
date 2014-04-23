require 'rspec'
$:.unshift File.expand_path('../../', __FILE__)
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


end