# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_mocker/version'

Gem::Specification.new do |spec|
  spec.name          = "active_mocker"
  spec.version       = ActiveMocker::VERSION
  spec.authors       = ["Dustin Zeisler"]
  spec.email         = ["dustin@zive.me"]
  spec.summary       = %q{Creates mocks from Active Record models. Allows your test suite to run very fast by not loading Rails or hooking to a database.}
  spec.description   = %q{Creates mocks from Active Record models. Allows your test suite to run very fast by not loading Rails or hooking to a database. It parse the schema definition and the defined methods on a model then saves a ruby file that can be included with a test. Mocks are regenerated when the schema is modified so your mocks will not go stale. This prevents the case where your units tests pass but production code is failing.}
  spec.homepage      = "https://github.com/zeisler/active_mocker"
  spec.license       = "MIT"

  spec.files         = Dir["lib/active_mocker/**/*", "lib/active_mocker.rb"]
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.0.0'

  spec.add_runtime_dependency "activesupport", "~>4.1"
  spec.add_runtime_dependency "virtus", '~> 1.0'
  spec.add_runtime_dependency "ruby-progressbar", '~> 1.4'

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake", "~>10.1"
  spec.add_development_dependency "rspec", "2.14.1"
  spec.add_development_dependency "sqlite3", "~>1.3"
  spec.add_development_dependency "rails", "~>4.1"
  spec.add_development_dependency "rspec-rails", "2.14.1"
  spec.add_development_dependency "fuubar", "~>1.3"
  spec.add_development_dependency "rspec-given", "~>3.5"
  spec.add_development_dependency "mutant", "~>0.5"
  spec.add_development_dependency "mutant-rspec", "~>0.5"
  spec.add_development_dependency "ruby-prof", "~>0.15"

  if ENV['DEBUG'] == '1'
    spec.add_development_dependency "debase", "~>0.0"
    spec.add_development_dependency "ruby-debug-ide", "~>0.4"
  end

end
