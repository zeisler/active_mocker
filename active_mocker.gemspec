# coding: utf-8
# frozen_string_literal: true
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "active_mocker/version"

Gem::Specification.new do |spec|
  spec.name          = "active_mocker"
  spec.version       = ActiveMocker::VERSION
  spec.authors       = ["Dustin Zeisler"]
  spec.email         = ["dustin@zeisler.net"]
  spec.summary       = "Creates mocks from Active Record models. Allows your test suite to run very fast by not loading Rails or a database."
  spec.description   = "ActiveMocker creates mock classes from ActiveRecord models, allowing your test suite to run at breakneck speed. This can be done by not loading Rails or hitting a database. The models are read dynamically and statically so that ActiveMocker can generate a Ruby file to require within a test. The mock file can be run by itself and comes with a partial implementation of ActiveRecord. Attributes and associations can be used the same as in ActiveRecord. Methods have the same argument signature but raise a NotImplementedError when called, allowing you to stub it with a mocking framework, like RSpec. Mocks are regenerated when the schema is modified so your mocks won't go stale, preventing the case where your units tests pass but production code fails."
  spec.homepage      = "https://github.com/zeisler/active_mocker"
  spec.license       = "MIT"

  spec.files         = Dir["CHANGELOG.md", "LICENSE.txt", "README.md", "lib/**/*"]

  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.1"

  spec.add_runtime_dependency "activesupport", "~>4.0"
  spec.add_runtime_dependency "virtus", "~> 1.0"
  spec.add_runtime_dependency "ruby-progressbar", "~> 1.7"
  spec.add_runtime_dependency "colorize", "~> 0.7"
  spec.add_runtime_dependency "rake", ">= 10.0"
  spec.add_runtime_dependency "reverse_parameters", "~> 0.4.0"
  spec.add_runtime_dependency "active_record_schema_scrapper", "~> 0.2.2"
  spec.add_runtime_dependency "dissociated_introspection", "~> 0.4.1"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rubocop", "~> 0.38.0"
  spec.add_development_dependency "rspec", "~> 3.4"
end
