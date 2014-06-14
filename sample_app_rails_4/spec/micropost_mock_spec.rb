require 'rspec'
$:.unshift File.expand_path('../../', __FILE__)
APP_ROOT = File.expand_path('../../', __FILE__) unless defined? APP_ROOT
require 'config/initializers/active_mocker.rb'
load 'spec/mocks/micropost_mock.rb'
load 'spec/mocks/user_mock.rb'

describe MicropostMock do

  before(:each){
    ActiveMocker::Generate.new
    MicropostMock.clear_mock
    UserMock.clear_mock
  }

  describe 'user=' do

    it 'setting user will assign its foreign key' do
      user = UserMock.create!
      post = MicropostMock.create(user: user)
      expect(post.user_id).to eq user.id
    end

    it 'setting user will not assign its foreign key if the object does not respond to persisted?' do
      user = {}
      post = MicropostMock.create(user: user)
      expect(post.user_id).to eq nil
    end

  end

  describe '::MAGIC_ID_NUMBER' do

    it 'has constant from model' do

      expect(MicropostMock::MAGIC_ID_NUMBER).to eq 90

    end

  end

  describe '::MAGIC_ID_STRING' do

    it 'has constant from model' do

      expect(MicropostMock::MAGIC_ID_STRING).to eq 'F-1'

    end

  end

  describe '::constants' do

    it 'has constant from model' do

      expect(MicropostMock.constants).to eq [:MAGIC_ID_NUMBER, :MAGIC_ID_STRING, :ClassMethods]

    end

  end

  describe 'Mocking methods' do

    before do
      MicropostMock.mock_instance_method(:display_name) do
        'Method Mocked at class level'
      end
    end

    it 'when no instance level mocks is set will default to class level' do
      expect(MicropostMock.new.display_name).to eq 'Method Mocked at class level'

    end

    it 'instance mocking overrides class mocking' do
      post = MicropostMock.new
      post.mock_instance_method(:display_name) do
        'Method Mocked at instance level'
      end
      expect(post.display_name).to eq 'Method Mocked at instance level'
    end

  end

  after(:each) do
    MicropostMock.delete_all
    UserMock.delete_all
  end

end