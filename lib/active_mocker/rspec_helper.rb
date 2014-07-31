require 'active_mocker/loaded_mocks'

RSpec.configure do |config|

  def mock_class(class_name)
    return class_name.constantize if defined?(Rails) && !self.class.metadata[:active_mocker]
    ActiveMocker::LoadedMocks.class_name_to_mock.select { |name, mock| name == class_name }.values.first
  end

  config.before(:each, active_mocker: true) do
    unless  ENV['RUN_WITH_RAILS'] && self.class.metadata[:rails_compatible]
      ActiveMocker::LoadedMocks.class_name_to_mock.each { |class_name, mock| stub_const(class_name, mock) }
    end
  end

  config.after(:all) do
    ActiveMocker::LoadedMocks.clear_all if self.class.metadata[:active_mocker]
  end

end
