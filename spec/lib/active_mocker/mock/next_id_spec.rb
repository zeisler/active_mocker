require 'rspec'
$:.unshift File.expand_path('../../../../../lib/active_mocker/mock', __FILE__)
require 'next_id'
require 'exceptions'
require 'ostruct'

describe ActiveMocker::Mock::NextId do

  describe '#next' do

    context 'when has ordered records' do

      let(:given_records) { [OpenStruct.new(id: 1), OpenStruct.new(id: 2)] }

      it { expect(described_class.new(given_records).next).to eq 3 }

    end

    context 'when has unordered records' do

      let(:given_records) { [OpenStruct.new(id: 2), OpenStruct.new(id: 1)] }

      it { expect(described_class.new(given_records).next).to eq 3 }

    end

    context 'when has no records' do

      let(:given_records) { [] }

      it { expect(described_class.new(given_records).next).to eq 1 }

    end

    context 'when has records with string ids' do

      let(:given_records) { [OpenStruct.new(id: '1')] }

      it { expect{described_class.new(given_records).next}.to raise_error(ActiveMocker::Mock::IdNotNumber) }

    end

  end

end