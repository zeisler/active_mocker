require "rails"
require "yaml"

module ActiveMocker
  class Railtie < ::Rails::Railtie
    rake_tasks do
      load "active_mocker/task.rake"
    end
  end
end
