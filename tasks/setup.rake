# frozen_string_literal: true
desc "setup"
task :setup do
  unless ENV["TRAVIS"]
    Bundler.with_clean_env do
      rails_test_gemfile = File.expand_path(File.dirname(__FILE__) + "/../test_rails_4_app/Gemfile")
      sh "BUNDLE_GEMFILE=#{rails_test_gemfile} bundle install --local 2>&1 >/dev/null" do |ok, _res|
        sh "BUNDLE_GEMFILE=#{rails_test_gemfile} bundle install" unless ok
      end
      Dir.chdir("test_rails_4_app") do
        sh "appraisal bundle install"
      end
    end
  end
  Dir.chdir("test_rails_4_app") do
    sh "bin/rails db:environment:set RAILS_ENV=development"
    sh "rake db:setup"
  end
end
