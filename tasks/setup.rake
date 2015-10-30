task :setup do
  Bundler.with_clean_env do
    rails_test_gemfile = File.expand_path(File.dirname(__FILE__)+ "/../test_rails_4_app/Gemfile")
    sh "BUNDLE_GEMFILE=#{rails_test_gemfile} bundle install --local 2>&1 >/dev/null" do |ok, res|
      sh "BUNDLE_GEMFILE=#{rails_test_gemfile} bundle install" unless ok
    end
    Dir.chdir("test_rails_4_app") do
      sh "BUNDLE_GEMFILE=#{rails_test_gemfile} bundle exec appraisal install 2>&1 >/dev/null"
    end
  end
end