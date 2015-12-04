require 'rails_helper'
require 'mocks/identity_mock'

describe IdentityMock do

  it 'has base class of Base' do
    expect(described_class.superclass).to eq ActiveMocker::Base
  end

end