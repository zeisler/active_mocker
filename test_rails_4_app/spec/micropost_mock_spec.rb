require 'rspec'
$:.unshift File.expand_path('../../', __FILE__)
APP_ROOT = File.expand_path('../../', __FILE__) unless defined? APP_ROOT
require 'lib/post_methods'
require_relative 'mocks/micropost_mock.rb'
require_relative 'mocks/user_mock.rb'

describe MicropostMock do

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

  context 'included methods' do

    it 'has methods' do

      expect(MicropostMock.new.respond_to?(:sample_method)).to eq true

    end

    it 'can override attributes' do
      post = MicropostMock.new(content: 'attribute')
      expect(post.content).to eq 'from PostMethods'

    end

  end

  context 'extended methods' do

    it 'has methods' do

      expect(MicropostMock.respond_to?(:sample_method)).to eq true

    end

  end

  describe '::MAGIC_ID_STRING' do

    it 'has constant from model' do

      expect(MicropostMock::MAGIC_ID_STRING).to eq 'F-1'

    end

  end

  describe '::constants' do

    it 'has constant from model' do

      expect(MicropostMock.constants).to include(:MAGIC_ID_NUMBER, :MAGIC_ID_STRING)

    end

  end

  describe 'has_one#create_attribute' do

    let(:post){ MicropostMock.new}

    it 'can create off of has_one' do
      user = post.create_user
      expect(post.user).to eq user
      expect(user.persisted?).to eq true
    end

  end

  describe 'has_one#build_attribute' do

    let(:post) { MicropostMock.new }

    it 'can create off of has_one' do
      user = post.build_user
      expect(post.user).to eq user
      expect(user.persisted?).to eq false
    end

  end

  describe 'Mocking methods' do

    context 'mocked from class before new' do

      before do
        allow_any_instance_of(MicropostMock).to receive(:display_name) do
          'Method Mocked at class level'
        end
      end

      it 'when no instance level mocks is set will default to class level' do
        expect(MicropostMock.new.display_name).to eq 'Method Mocked at class level'
      end

      it 'instance mocking overrides class mocking' do
        post = MicropostMock.new
        allow(post).to receive(:display_name) do
          'Method Mocked at instance level'
        end
        expect(post.display_name).to eq 'Method Mocked at instance level'
      end

    end

  end

  describe 'Sub classing' do

    context 'using sub class' do

      before do
        class SubUserMock < UserMock
        end
      end

      let(:given_a_sub_user_record) { SubUserMock.create }
      let(:given_a_post) { MicropostMock.create(user_id: given_a_sub_user_record.id) }

      it 'when setting #user_id it will set #user from sub class' do
        expect(given_a_post.user).to eq given_a_sub_user_record
        expect(given_a_post.user.class).to eq SubUserMock
      end

    end

    context 'without a sub class' do

      let(:given_a_sub_user_record) { UserMock.create }
      let(:given_a_post) { MicropostMock.create(user_id: given_a_sub_user_record.id) }

      it 'when setting #user_id it will set #user from sub class' do
        expect(given_a_post.user).to eq given_a_sub_user_record
        expect(given_a_post.user.class).to eq UserMock
      end

    end

  end

  after(:each) do
    ActiveMocker::LoadedMocks.clear_all
  end

end