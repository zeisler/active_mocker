require 'spec_helper'
require 'active_mocker/rspec_helper'
require 'lib/post_methods'
require_relative 'mocks/micropost_mock.rb'
require_relative 'mocks/user_mock.rb'

describe MicropostMock, active_mocker: true do
  context 'find mock in :all context' do
    before :all do
      active_mocker.mocks.find(:Micropost).create!
      active_mocker.mocks.find(:Micropost).create!
      active_mocker.mocks.find(:Micropost).create!
    end

    after do
      active_mocker.mocks.except(Micropost).delete_all
    end

    before do
      User.create

      class UserDec < User
      end
    end

    context 'inner' do
      it 'will create an instance of mock' do
        expect(Micropost.count).to eq 3
        expect(Micropost.first.class.name).to eq "A4dbc79441c3::Micropost"
        expect(active_mocker.mocks.mocks.map(&:_uniq_key_for_record_context).uniq).to eq(["4dbc79441c34ab5ed80d0f53a317f029"])
      end

      it 'test user count' do
        expect(User.count).to eq 1
      end
    end

  end
end

describe 'Another Example', active_mocker: true do
  context '#mock_class' do

    before do
      active_mocker.mocks.find('Micropost').create!
      User.create
      active_mocker.mocks.except(User).delete_all
    end

    after do
      active_mocker.mocks.find(User).delete_all
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