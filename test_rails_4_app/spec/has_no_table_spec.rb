# frozen_string_literal: true
require "rails_helper"
require_mock "has_no_table_mock"

describe HasNoTableMock do
  it "will raise error on initialization" do
    expect { described_class.new }.to raise_error("HasNoTableMock is an abstract class and cannot be instantiated.")
  end
end
