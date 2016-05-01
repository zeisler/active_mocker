# frozen_string_literal: true
require "rails_helper"
require_mock "api/customer_mock"

RSpec.describe Api::CustomerMock do
  describe "::mocked_class" do
    it "returns the class name with the namespace" do
      expect(described_class.send(:mocked_class)).to eq "Api::Customer"
    end
  end
end
