require 'rspec'
$:.unshift File.expand_path('../../', __FILE__)
APP_ROOT = File.expand_path('../../', __FILE__) unless defined? APP_ROOT

RSpec.configure do |config|

  config.order                      = "random"

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

end