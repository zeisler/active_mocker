require 'rails_helper'
require_mock 'user_mock'
require_mock 'account_mock'

describe AccountMock do

  it 'has_one user' do
    user = UserMock.create
    account = described_class.new(user: user)
    expect(user.account).to eq account
  end

end
