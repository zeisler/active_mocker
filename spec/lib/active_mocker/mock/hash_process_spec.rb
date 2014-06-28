require 'rspec'
$:.unshift File.expand_path('../../../../../lib/active_mocker/mock', __FILE__)
require 'hash_process'
describe ActiveMocker::Mock::HashProcess do

  it do
    subject = described_class.new({id: 1 }, ->(val){ val * 2 })
    expect(subject[:id]).to eq 2
  end

end