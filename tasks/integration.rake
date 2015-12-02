task :integration do
  Dir.chdir("test_rails_4_app") do
    if ENV["TRAVIS"]
      sh "MUTE_PROGRESS_BAR=true ERROR_VERBOSITY=0  bundle exec rake active_mocker:build"
      sh "bundle exec rspec"
    else
      Bundler.with_clean_env do
        rails_test_gemfile = File.expand_path(File.dirname(__FILE__)+ "/../test_rails_4_app/Gemfile")
        sh "MUTE_PROGRESS_BAR=true ERROR_VERBOSITY=0 BUNDLE_GEMFILE=#{rails_test_gemfile} bundle exec appraisal rake active_mocker:build"
        sh "BUNDLE_GEMFILE=#{rails_test_gemfile} bundle exec appraisal rspec"
      end
    end
  end
end