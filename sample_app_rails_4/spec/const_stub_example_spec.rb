require 'rspec'
require 'active_mocker/rspec_helper'
$:.unshift File.expand_path('../../', __FILE__)
APP_ROOT = File.expand_path('../../', __FILE__) unless defined? APP_ROOT
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