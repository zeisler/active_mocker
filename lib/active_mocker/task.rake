# frozen_string_literal: true

namespace :active_mocker do
  desc("Rebuild mocks.")
  task build: :environment do
    ActiveMocker.configure do |c|
      c.single_model_path             = ENV["MODEL"] if ENV["MODEL"]
      c.model_dir                     = ENV["MODEL_DIR"] if ENV["MODEL_DIR"]
      c.mock_dir                      = ENV["MOCK_DIR"] if ENV["MOCK_DIR"]
      c.progress_bar                  = false if ENV["MUTE_PROGRESS_BAR"]
      c.error_verbosity               = ENV["ERROR_VERBOSITY"].to_i if ENV["ERROR_VERBOSITY"]
      c.disable_modules_and_constants = false
    end.create_mocks
  end

  desc("Run all tests tagged   active_mocker")
  task :test do
    sh "rspec --tag active_mocker"
  end

  desc("Run all tests tagged active_mocker and rails_compatible and will disable model stubbing")
  task :rails_compatible do
    sh "RUN_WITH_RAILS=1 rspec --tag rails_compatible"
  end
end

["db:migrate", "db:rollback"].each do |task|
  Rake::Task[task].enhance do
    Rake::Task["active_mocker:build"].invoke
  end
end
