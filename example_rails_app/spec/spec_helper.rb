require 'active_mocker/rspec_helper'
$:.unshift File.join(File.expand_path('../../', __FILE__)) # add root of app to path
RSpec.configure do |config|

  config.order = 'random'
  config.mock_framework = :rspec
  config.disable_monkey_patching!
  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect
    mocks.verify_doubled_constant_names = true
    mocks.verify_partial_doubles = true
  end

end
