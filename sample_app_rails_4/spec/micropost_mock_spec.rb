require 'rspec'
$:.unshift File.expand_path('../../', __FILE__)

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



  after(:each) do
    MicropostMock.delete_all
    UserMock.delete_all
  end


end