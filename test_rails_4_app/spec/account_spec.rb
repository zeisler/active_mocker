require 'rails_helper'
require_relative 'mocks/user_mock.rb'
require_relative 'mocks/account_mock'

describe AccountMock do

  it 'has_one user' do
    user = UserMock.create
    account = described_class.new(user: user)
    expect(user.account).to eq account
  end

end