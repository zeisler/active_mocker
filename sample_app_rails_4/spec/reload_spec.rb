require 'rspec'


RSpec.configure do |config|
  config.after(:all) do
    ActiveMocker::LoadedMocks.all.each{|n, m| m.reload}
  end

  config.before(:all) do
    ActiveMocker::LoadedMocks.reload_all
  end
end

$:.unshift File.expand_path('../../', __FILE__)
APP_ROOT = File.expand_path('../../', __FILE__)
require 'config/initializers/active_mocker.rb'
load 'mocks/user_mock.rb'

describe 'Mock::reload should change state of mock'do

    before(:each) do
      class UserMock
        def self.new_method
        end
      end
    end

    it 'will reload the Mock file' do
      expect(UserMock.respond_to?(:new_method)).to eq true
      UserMock.create
    end

end

describe 'Mock::reload should have fresh mock' do

  it 'will reload the Mock file' do
    expect(UserMock.respond_to?(:new_method)).to be_false
  end

end
