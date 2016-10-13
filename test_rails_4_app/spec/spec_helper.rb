# frozen_string_literal: true
require "rspec"
$LOAD_PATH.unshift File.expand_path("../../", __FILE__)
APP_ROOT = File.expand_path("../../", __FILE__) unless defined? APP_ROOT

RSpec.configure do |config|
  config.order = "random"

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_doubled_constant_names = true
    mocks.verify_partial_doubles        = true
  end
end

def require_mock(name)
  require "#{mock_path}/#{name}"
end

def mock_path
  rails_version = if ENV["RAILS_VERSION"]
                    ENV["RAILS_VERSION"]
                  elsif defined? Rails
                    "rails_#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}"
                  else
                    "rails_5.0"
                  end
  File.join(APP_ROOT, "spec/mocks/#{rails_version}")
end
