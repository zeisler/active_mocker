module ActiveMocker
  class Railtie < Rails::Railtie

    rake_tasks do
      load 'active_mocker/task.rake'
    end

    config.to_prepare do
      ActiveMocker::Config.set do |config|
        config.schema_file = File.join(Rails.root, 'db/schema.rb')
        config.model_dir   = File.join(Rails.root, 'app/models')
        config.mock_dir    = File.join(Rails.root, 'spec/mocks')
        config.model_base_classes = %w[ ActiveRecord::Base ]
        config.logger      = Rails.logger
      end
    end
  end
end