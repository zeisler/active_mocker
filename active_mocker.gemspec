# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_mocker/version'

Gem::Specification.new do |spec|
  spec.name          = "active_mocker"
  spec.version       = ActiveMocker::VERSION
  spec.authors       = ["Dustin Zeisler"]
  spec.email         = ["dustin@zive.me"]
  spec.summary       = %q{TODO: Write a short summary. Required.}
  spec.description   = %q{TODO: Write a longer description. Optional.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "i18n"
  spec.add_development_dependency "active_support"

  spec.add_development_dependency "debase", "~>0.0"
  spec.add_development_dependency "ruby-debug-ide", "~>0.4"

end
