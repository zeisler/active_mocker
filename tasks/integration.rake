task :integration do
  Dir.chdir("test_rails_4_app") do
    root = File.expand_path('../../', __FILE__)
    if ENV["TRAVIS"]
      rails_version = File.open(File.join(root, "Gemfile")).read.scan(/['|"]rails['|"].*~>\s?(\d.\d)/).first.first
      rails_version = "rails_#{rails_version}"
      sh "RAILS_VERSION=#{rails_version} MUTE_PROGRESS_BAR=true ERROR_VERBOSITY=2 rake active_mocker:build"
      sh "rspec"
    else
      Bundler.with_clean_env do
        Dir[Pathname(File.join(root, "test_rails_4_app/gemfiles/*.gemfile")).expand_path].each do |gemfile|
          rails_version = Pathname(gemfile).basename.to_s.gsub(".gemfile", "")
          mock_dir      = File.expand_path(File.join(root, "test_rails_4_app/spec/mocks", rails_version))
          sh "RAILS_VERSION=#{rails_version} MOCK_DIR=#{mock_dir} MUTE_PROGRESS_BAR=true ERROR_VERBOSITY=0 BUNDLE_GEMFILE=#{gemfile} bundle exec rake active_mocker:build"
          sh "RAILS_VERSION=#{rails_version} BUNDLE_GEMFILE=#{gemfile} bundle exec rspec"
        end
      end
    end
  end
end
