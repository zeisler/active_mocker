require 'rspec'

RSpec.configure do |config|
  config.after(:all) do
    ActiveMocker::LoadedMocks.clear_all
  end

  config.before(:all) do
    ActiveMocker::LoadedMocks.clear_all
  end
end

$:.unshift File.expand_path('../../', __FILE__)
APP_ROOT = File.expand_path('../../', __FILE__)
require 'config/initializers/active_mocker.rb'
load 'mocks/user_mock.rb'

describe 'Should change state of mock'do

    before(:each) do
      UserMock.create

      UserMock.mock_class_method(:digest) do |token|
        token
      end
    end

    it 'should change record count and digest should be implemented' do
      expect(UserMock.count).to eq 1
      expect(UserMock.digest('token')).to eq 'token'
    end

end

describe 'should have fresh mock' do

  it 'should have record count of zero' do
    expect(UserMock.count).to eq 0
  end

  it 'should raise error when calling digest' do
    expect{UserMock.digest(nil)}.to raise_error(RuntimeError, '::digest is not Implemented for Class: UserMock')
  end

end
