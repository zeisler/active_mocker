desc "Run unit specs"
task :unit do
  sh "bundle exec rspec"
end
