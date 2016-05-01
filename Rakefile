# frozen_string_literal: true
require "rubygems"
require "bundler/setup"
require "bundler/gem_tasks"
Dir.glob("tasks/*.rake").each { |r| import r }

task default: "specs"

desc "run setup and tests"
task :specs do
  Rake::Task["setup"].invoke
  Rake::Task["unit"].invoke
  Rake::Task["integration"].invoke
end

desc "run tests"
task :test do
  Rake::Task["unit"].invoke
  Rake::Task["integration"].invoke
end
