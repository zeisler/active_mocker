# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_mocker/version'

Gem::Specification.new do |spec|
  spec.name          = "active_mocker"
  spec.version       = ActiveMocker::VERSION
  spec.authors       = ["Dustin Zeisler"]
  spec.email         = ["dustin@zive.me"]
  spec.summary       = %q{Create mocks from active record models without loading rails or running a database}
  spec.description   = %q{Create mocks from active record models without loading rails or running a database. The Mock's methods have the same arguments as the AR model and if they change you get a error in your test.}
  spec.homepage      = "https://github.com/zeisler/active_mocker"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.0.0'

  spec.add_runtime_dependency "activerecord", "~>4.1"
  spec.add_runtime_dependency "activesupport", "~>4.1"
  spec.add_runtime_dependency "active_hash", "~>1.3"

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake", "~>10.1"
  spec.add_development_dependency "rspec", "~>2.14"
  spec.add_development_dependency "sqlite3", "~>1.3"
  spec.add_development_dependency "rails", "~>4.1"
  spec.add_development_dependency "rspec-rails", "~>2"
  spec.add_development_dependency "fuubar", "~>1.3"

  if ENV['DEBUG'] == '1'
    spec.add_development_dependency "debase", "~>0.0"
    spec.add_development_dependency "ruby-debug-ide", "~>0.4"
  end

end
