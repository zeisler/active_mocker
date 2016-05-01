# frozen_string_literal: true
require "spec_helper"
require "lib/post_methods"
require_mock "micropost_mock"
require_mock "user_mock"

describe MicropostMock do
  describe "user=" do
    it "setting user will assign its foreign key" do
      user = UserMock.create!
      post = MicropostMock.create(user: user)
      expect(post.user_id).to eq user.id
    end
  end

  describe "::MAGIC_ID_NUMBER" do
    it "has constant from model" do
      expect(MicropostMock::MAGIC_ID_NUMBER).to eq 90
    end
  end

  context "included methods" do
    it "has methods" do
      expect(MicropostMock.new.respond_to?(:sample_method)).to eq true
    end

    it "can override attributes" do
      post = MicropostMock.new(content: "attribute")
      expect(post.content).to eq "from PostMethods"
    end
  end

  context "extended methods" do
    it "has methods" do
      expect(MicropostMock.respond_to?(:sample_method)).to eq true
    end
  end

  describe "::MAGIC_ID_STRING" do
    it "has constant from model" do
      expect(MicropostMock::MAGIC_ID_STRING).to eq "F-1"
    end
  end

  describe "::constants" do
    it "has constant from model" do
      expect(MicropostMock.constants).to include(:MAGIC_ID_NUMBER, :MAGIC_ID_STRING)
    end
  end

  describe 'has_one#create_attribute' do
    let(:post) { MicropostMock.new }

    it "can create off of has_one" do
      user = post.create_user
      expect(post.user).to eq user
      expect(user.persisted?).to eq true
    end
  end

  describe 'has_one#build_attribute' do
    let(:post) { MicropostMock.new }

    it "can create off of has_one" do
      user = post.build_user
      expect(post.user).to eq user
      expect(user.persisted?).to eq false
    end
  end

  describe "Mocking methods" do
    context "mocked from class before new" do
      before do
        allow_any_instance_of(MicropostMock).to receive(:display_name) do
          "Method Mocked at class level"
        end
      end

      it "when no instance level mocks is set will default to class level" do
        expect(MicropostMock.new.display_name).to eq "Method Mocked at class level"
      end

      it "instance mocking overrides class mocking" do
        post = MicropostMock.new
        allow(post).to receive(:display_name) do
          "Method Mocked at instance level"
        end
        expect(post.display_name).to eq "Method Mocked at instance level"
      end
    end
  end

  after(:each) do
    ActiveMocker::LoadedMocks.clear_all
  end
end
