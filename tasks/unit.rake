task :unit do
  sh "bundle exec rspec #{ENV["TRAVIS"] ? "--tag ~skip_travis:true" : ""}"
end