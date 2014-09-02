require 'spec_helper'
require 'active_mocker/mock/hash_process'

describe ActiveMocker::Mock::HashProcess do

  it do
    subject = described_class.new({id: 1 }, ->(val){ val * 2 })
    expect(subject[:id]).to eq 2
  end

  it 'merge' do
    hash1 = described_class.new({id: 1}, ->(val) { val })
    hash2 = described_class.new({value: 2}, ->(val) { val })
    subject = hash1.merge(hash2)
    expect(subject.hash).to eq( { :id => 1, :value => 2 } )
  end

end