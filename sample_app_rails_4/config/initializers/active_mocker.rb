require 'active_mocker'
root = APP_ROOT unless defined? Rails
root = Rails.root if defined? Rails
require "#{root}/lib/unit_logger"
ActiveMocker::Generate.configure do |config|
  # Required Options
  config.schema_file = File.join(root, 'db/schema.rb')
  config.model_dir   = File.join(root, 'app/models')
  config.mock_dir    = File.join(root, 'spec/mocks')
  # Logging
  config.logger      = UnitLogger
end