# frozen_string_literal: true
desc "run integration specs"
task :integration do
  Dir.chdir("test_rails_4_app") do
    root = File.expand_path("../../", __FILE__)
    gemfiles, error_verbosity = if ENV["TRAVIS"]
                                  [[ENV["BUNDLE_GEMFILE"]], "3"]
                                else
                                  [Dir[Pathname(File.join(root, "test_rails_4_app/gemfiles/*.gemfile")).expand_path], 0]
               end
    Bundler.with_clean_env do
      gemfiles.each do |gemfile|
        rails_version = Pathname(gemfile).basename.to_s.gsub(".gemfile", "")
        mock_dir      = File.expand_path(File.join(root, "test_rails_4_app/spec/mocks", rails_version))
        sh "RAILS_VERSION=#{rails_version} MOCK_DIR=#{mock_dir} MUTE_PROGRESS_BAR=true ERROR_VERBOSITY=#{error_verbosity} BUNDLE_GEMFILE=#{gemfile} bundle exec rake active_mocker:build"
        sh "RAILS_VERSION=#{rails_version} BUNDLE_GEMFILE=#{gemfile} bundle exec rspec"
      end
    end
  end
end
