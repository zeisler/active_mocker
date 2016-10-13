# frozen_string_literal: true
require "active_mocker/loaded_mocks"
require "active_mocker/rspec"

RSpec.configure do |config|
  config.include ActiveMocker::Rspec

  config.before(:each, active_mocker: true) do
    unless ENV["RUN_WITH_RAILS"] && self.class.metadata[:rails_compatible]
      active_mocker.mocks.each { |class_name, mock| stub_const(class_name, mock) }
    end
    stub_const("ActiveRecord::RecordNotFound", ActiveMocker::RecordNotFound)
  end

  config.after(:all, active_mocker: true) do
    ActiveMocker::LoadedMocks.delete_all
  end

  config.before(:all, active_mocker: true) do
    ActiveMocker::LoadedMocks.delete_all
  end
end
