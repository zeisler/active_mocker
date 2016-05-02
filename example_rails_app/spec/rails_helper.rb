# frozen_string_literal: true
ENV["RAILS_ENV"] ||= "test"
require "spec_helper"
require File.expand_path("../../config/environment", __FILE__)
require "rspec/rails"

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.use_transactional_fixtures = true

  config.infer_spec_type_from_file_location!

  require "nosql"
  # ensure no database connections
  config.around(:each, no_db: true) do |example|
    Nosql::Connection.enable!
    example.run
    Nosql::Connection.disable!
  end
end
