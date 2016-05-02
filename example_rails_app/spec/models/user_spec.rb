require "rails_helper"
require "spec/mocks/user_mock"

RSpec.describe User, no_db: true do
  let(:code) do
    lambda do
      user = User.create name: "Mark"
      expect(user.reload.name).to eq "Mark"
    end
  end

  context "with active mocker in use", active_mocker: true do
    it "doesn't touch the db with the nosql gem in use" do
      expect{code.call}.not_to raise_error Nosql::Error
    end
  end

  context "with active mocker in use", active_mocker: false do
    it "touches the db" do
      expect{code.call}.to raise_error Nosql::Error, ["PRAGMA table_info(\"users\")", "SCHEMA"].inspect
    end
  end
end
