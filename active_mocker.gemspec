# coding: utf-8
# frozen_string_literal: true
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "active_mocker/version"

Gem::Specification.new do |spec|
  spec.name        = "active_mocker"
  spec.version     = ActiveMocker::VERSION
  spec.authors     = ["Dustin Zeisler"]
  spec.email       = ["dustin@zeisler.net"]
  spec.summary     = "Creates stub classes from any ActiveRecord model"
  spec.description = "Creates stub classes from any ActiveRecord model. By using stubs in your tests you don't need to load Rails or the database, sometimes resulting in a 10x speed improvement. ActiveMocker analyzes the methods and database columns to generate a Ruby class file. The stub file can be run standalone and comes included with many useful parts of ActiveRecord. Stubbed out methods contain their original argument signatures or ActiveMocker friendly code can be brought over in its entirety. Mocks are regenerated when the schema is modified so your mocks won't go stale, preventing the case where your unit tests pass but production code fails."
  spec.homepage    = "https://github.com/zeisler/active_mocker"
  spec.license     = "MIT"

  spec.files         = Dir["CHANGELOG.md", "LICENSE.txt", "README.md", "lib/**/*"]

  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.1"

  spec.add_runtime_dependency "activesupport", ">= 4.1"
  spec.add_runtime_dependency "virtus", "~> 1.0"
  spec.add_runtime_dependency "ruby-progressbar", "~> 1.7"
  spec.add_runtime_dependency "colorize", "~> 0.7", ">= 0.7"
  spec.add_runtime_dependency "rake", ">= 10.0"
  spec.add_runtime_dependency "reverse_parameters", "~> 1.1", ">= 1.1.1"
  spec.add_runtime_dependency "active_record_schema_scrapper", "~> 0.6", ">= 0.6.0"
  spec.add_runtime_dependency "dissociated_introspection", "~> 0.9", ">= 0.9.1"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rubocop", "~> 0.38.0"
  spec.add_development_dependency "rspec", "~> 3.4"
end
