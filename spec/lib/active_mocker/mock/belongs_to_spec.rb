require 'spec_helper'
require 'active_mocker/mock'
require 'active_mocker/mock/belongs_to'
describe ActiveMocker::BelongsTo do

  it 'item can be an non ActiveMock that does not respond to save' do
    described_class.new(double('NonActiveMocker'), child_self: double('ActiveMocker', persisted?: true, write_attribute: true), foreign_key: 1)
  end

end