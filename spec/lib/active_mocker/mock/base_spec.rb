# frozen_string_literal: true
require "spec_helper"
require "logger"
require "active_mocker/mock"
require_relative "queriable_shared_example"
describe ActiveMocker::Base do
  class ActiveMocker::Base
    class << self
      def abstract_class?
        false
      end

      attr_writer :records
    end

    def id
      self.class.attributes[:id]
    end

    def id=(val)
      self.class.attributes[:id] = val
    end
  end

  it_behaves_like "Queriable", -> (*args) {
    ActiveMocker::Base.clear_mock
    ActiveMocker::Base.send(:records=, ActiveMocker::Records.new(args.flatten))
    ActiveMocker::Base
  }

  describe "destroy" do
    subject { described_class.create }

    it "will delegate to delete" do
      subject.destroy
      expect(described_class.count).to eq 0
    end
  end

  describe "::_find_associations_by_class" do
    it do
      allow(ActiveMocker::Base).to receive(:associations_by_class) { { "User" => [:customers] } }
      result = described_class._find_associations_by_class("User")
      expect(result).to eq [:customers]
    end
  end

  before do
    described_class.delete_all
  end

  after do
    described_class.delete_all
  end
end
