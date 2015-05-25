require 'active_mocker/loaded_mocks'
require 'active_mocker/rspec'


RSpec.configure do |config|

  config.include ActiveMocker::Rspec

  config.before(:each, active_mocker: true) do
    unless ENV['RUN_WITH_RAILS'] && self.class.metadata[:rails_compatible]
      active_mocker.mocks.each { |class_name, mock| stub_const(class_name, mock) }
    end
  end

  config.after(:all, active_mocker: true) do
    if ActiveMocker::LoadedMocks.disable_global_state
      ActiveMocker::LoadedMocks.deallocate_scoped_set(active_mocker.send(:_am_uniq_key_for_example))
    else
      ActiveMocker::LoadedMocks.delete_all
    end
  end

end
