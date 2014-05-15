require 'active_mocker'

ActiveMocker::Generate.configure do |config|
  # Required Options
  config.schema_file = File.join(Rails.root, 'db/schema.rb')
  config.model_dir   = File.join(Rails.root, 'app/models')
  config.mock_dir    = File.join(Rails.root, 'spec/mocks')
  # Logging
  config.log_level = Logger::WARN       #default
end