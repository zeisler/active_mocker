require "bundler/gem_tasks"

task :default => 'specs'

task :specs do
  if defined?(RUBY_ENGINE) && RUBY_ENGINE == "ruby" && RUBY_VERSION >= "1.9"
    module Kernel
      alias :__at_exit :at_exit
      def at_exit(&block)
        __at_exit do
          exit_status = $!.status if $!.is_a?(SystemExit)
          block.call
          exit exit_status if exit_status
        end
      end
    end
  end
  sh "bundle exec rspec --seed #{random_seed}"
  sh "cd test_rails_4_app &&
        bundle exec appraisal bundle &&
        bundle exec appraisal rake active_mocker:build &&
        bundle exec appraisal rspec --seed #{random_seed}"
end

def random_seed
  seed = rand(99999)
  puts "Seed: #{seed}"
  seed
end
