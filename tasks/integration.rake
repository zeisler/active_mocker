task :integration do
  sh "cd test_rails_4_app &&
        bundle exec appraisal rake active_mocker:build 2>&1 >/dev/null &&
        bundle exec appraisal rspec"
end