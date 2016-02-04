task :integration do
  Dir.chdir("test_rails_4_app") do
    root     = File.expand_path('../../', __FILE__)
    gemfiles = if ENV["TRAVIS"]
                 [ENV["BUNDLE_GEMFILE"]]
               else
                 Dir[Pathname(File.join(root, "test_rails_4_app/gemfiles/*.gemfile")).expand_path]
               end
    Bundler.with_clean_env do
      gemfiles.each do |gemfile|
        rails_version = Pathname(gemfile).basename.to_s.gsub(".gemfile", "")
        mock_dir      = File.expand_path(File.join(root, "test_rails_4_app/spec/mocks", rails_version))
        sh "RAILS_VERSION=#{rails_version} MOCK_DIR=#{mock_dir} MUTE_PROGRESS_BAR=true ERROR_VERBOSITY=3 BUNDLE_GEMFILE=#{gemfile} bundle exec rake active_mocker:build"
        sh "RAILS_VERSION=#{rails_version} BUNDLE_GEMFILE=#{gemfile} bundle exec rspec"
      end
    end
  end
end
