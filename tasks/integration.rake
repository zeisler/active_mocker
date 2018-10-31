# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
desc "run integration specs"
task :integration do
  Dir.chdir("test_rails_app") do
    root                      = File.expand_path("../../", __FILE__)
    gemfiles, error_verbosity = if ENV["TRAVIS"]
                                  [[ENV["BUNDLE_GEMFILE"]], "1"]
                                else
                                  [Dir[Pathname(File.join(root, "test_rails_app/gemfiles/*.gemfile")).expand_path], 0]
                                end
    Bundler.with_clean_env do
      gemfiles.each do |gemfile|
        Pathname(gemfile).basename.to_s =~ /rails_(\d\.\d).*/
        rails_version = Regexp.last_match(1)
        mock_dir      = File.expand_path(File.join(root, "test_rails_app/spec/mocks", rails_version))
        sh <<~CMD.tr("\n", " ")
          RAILS_VERSION=#{Shellwords.escape(rails_version)}
          MOCK_DIR=#{Shellwords.escape(mock_dir)}
          MUTE_PROGRESS_BAR=true ERROR_VERBOSITY=#{error_verbosity}
          BUNDLE_GEMFILE=#{Shellwords.escape(gemfile)}
          bundle exec rake active_mocker:build
        CMD
        sh <<~CMD.tr("\n", " ")
          RAILS_VERSION=#{Shellwords.escape(rails_version)}
          BUNDLE_GEMFILE=#{Shellwords.escape(gemfile)}
          bundle exec rspec
        CMD
      end
    end
  end
end
