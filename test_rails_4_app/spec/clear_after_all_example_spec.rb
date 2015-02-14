require 'spec_helper'
require 'lib/post_methods'
require_relative 'mocks/micropost_mock.rb'
require_relative 'mocks/user_mock.rb'

describe MicropostMock, active_mocker: true do

  context 'will clear mock state before :all' do

    it 'make a record' do
      MicropostMock.create
    end

  end
end

describe MicropostMock, active_mocker: true do

  context 'will clear mock state before :all' do

    it 'count records' do
      expect(MicropostMock.count).to eq 0
    end

  end
end