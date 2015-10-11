task :setup do
  `bundle exec bundle install --local 2>&1 >/dev/null`
  sh "bundle install" unless $?.success?

  `cd test_rails_4_app && bundle install --local 2>&1 >/dev/null`
  sh "cd test_rails_4_app && bundle install" unless $?.success?
end