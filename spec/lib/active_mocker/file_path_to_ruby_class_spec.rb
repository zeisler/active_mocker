require "spec_helper"
require "active_mocker/file_path_to_ruby_class"
require "active_support/core_ext/string"

RSpec.describe ActiveMocker::FilePathToRubyClass do
  describe "#to_s" do

    subject { described_class.new(base_path:  base_path,
                                  class_path: class_path).to_s }

    context "single class" do
      let(:base_path) { "user/my_app/models" }
      let(:class_path) { "user/my_app/models/user.rb" }

      it { expect(subject).to eq "User" }
    end

    context "one deep namespaced class" do
      let(:base_path) { "user/my_app/models" }
      let(:class_path) { "user/my_app/models/api/user.rb" }

      it { expect(subject).to eq "Api::User" }
    end

    context "two deep namespaced class" do
      let(:base_path) { "user/my_app/models" }
      let(:class_path) { "user/my_app/models/api/b/user.rb" }

      it { expect(subject).to eq "Api::B::User" }
    end

    context "three deep namespaced class" do
      let(:base_path) { "user/my_app/models" }
      let(:class_path) { "user/my_app/models/api/b/c/user.rb" }

      it { expect(subject).to eq "Api::B::C::User" }
    end
  end
end
