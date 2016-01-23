require 'spec_helper'
require_mock 'user_mock'
require_relative "../../spec/lib/active_mocker/mock/queriable_shared_example"

describe UserMock do
  describe "ActiveMocker::MockRelation" do
    it_behaves_like 'Queriable', -> (*args) { ActiveMocker::MockRelation.new(UserMock, args.flatten) }

    subject { ActiveMocker::MockRelation.new(UserMock, collection) }
    let(:collection) { [UserMock.new, UserMock.new] }

    it "call a private method on class" do
      expect(UserMock).to receive(:__new_relation__).with(collection)
      subject
    end

    it "has the correct count" do
      expect(subject.count).to eq 2
    end

    it "has scoped methods" do
      expect(subject.respond_to?(:find_by_name)).to eq true
      expect(subject.respond_to?(:by_name)).to eq true
      expect(subject.respond_to?(:no_arg_scope)).to eq true
    end
  end
end
