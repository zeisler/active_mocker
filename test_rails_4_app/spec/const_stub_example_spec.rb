require 'spec_helper'
require 'active_mocker/rspec_helper'
require 'lib/post_methods'
require_relative 'mocks/micropost_mock.rb'
require_relative 'mocks/user_mock.rb'

describe 'Another Example', active_mocker: true do
  context '#mock_class' do

    before do
      active_mocker.mocks.find('Micropost').create!
      User.create
      active_mocker.mocks.except(User).delete_all
    end

    after do
      active_mocker.mocks.delete_all
    end

    it 'will create an instance of mock' do
      expect(Micropost.count).to eq 0
      expect(User.count).to eq 1
    end

    it 'will create an instance of mock 2' do
      expect(Micropost.count).to eq 0
      expect(User.count).to eq 1
    end

  end
end