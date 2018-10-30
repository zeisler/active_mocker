# frozen_string_literal: true
require "spec_helper"
require "active_mocker/rspec_helper"
require "lib/post_methods"
require_mock "micropost_mock"
require_mock "user_mock"

describe "1) State Not Shared between outer examples", active_mocker: true do
  context "state in one example will not leak to another" do
    it "make a record" do
      MicropostMock.create(content: "from 1) false")
    end
  end
end

describe "2) State Not Shared between outer examples", active_mocker: true do
  context "state in one example will not leak to another" do
    it "count records" do
      expect(MicropostMock.all.to_a).to eq([])
      expect(MicropostMock.count).to eq 0
    end
  end
end
