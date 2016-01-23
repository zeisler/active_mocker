require 'rails_helper'
require_mock 'identity_mock'

describe IdentityMock do

  it 'has base class of Base' do
    expect(described_class.superclass).to eq ActiveMocker::Base
  end

end
