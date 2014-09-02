module ActiveMocker
  class Railtie < Rails::Railtie

    rake_tasks do
      load 'active_mocker/task.rake'
    end

    config.to_prepare do
      ActiveMocker::Config.load_defaults
    end
  end
end