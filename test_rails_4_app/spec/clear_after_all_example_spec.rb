require 'spec_helper'
require 'active_mocker/rspec_helper'
require 'lib/post_methods'
require_relative 'mocks/micropost_mock.rb'
require_relative 'mocks/user_mock.rb'

describe '1) ActiveMocker::LoadedMocks.disable_global_state=true', active_mocker: true do
  context 'state in one example will not leak to another' do

    before(:all) do
      ActiveMocker::LoadedMocks.disable_global_state=true
    end

    it 'make a record' do
      Micropost.create
    end

  end
end

describe '2) ActiveMocker::LoadedMocks.disable_global_state=true', active_mocker: true do
  context 'state in one example will not leak to another' do

    before(:all) do
      ActiveMocker::LoadedMocks.disable_global_state=true
    end

    it 'count records' do
      expect(Micropost.count).to eq 0
    end

  end
end

describe '1) ActiveMocker::LoadedMocks.disable_global_state=false', active_mocker: true do
  context 'state in one example will not leak to another' do

    before(:all) do
      ActiveMocker::LoadedMocks.disable_global_state=false
    end

    it 'make a record' do
      MicropostMock.create(content: 'from 1) false')
    end

  end
end

describe '2) ActiveMocker::LoadedMocks.disable_global_state=false', active_mocker: true do
  context 'state in one example will not leak to another' do

    before(:all) do
      ActiveMocker::LoadedMocks.disable_global_state=false
    end

    it 'count records' do
      expect(MicropostMock.all.to_a).to eq([])
      expect(MicropostMock.count).to eq 0
    end

  end
end
