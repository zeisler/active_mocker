require 'spec_helper'
require 'active_mocker/rspec_helper'
require 'lib/post_methods'
require_relative 'mocks/micropost_mock.rb'
require_relative 'mocks/user_mock.rb'

describe MicropostMock, active_mocker:true do

  context '#mock_class' do

    before :all do
      mock_class('Micropost').create!
    end

    it 'will create an instance of mock' do
      expect(Micropost.first.class).to eq MicropostMock
    end

  end

end