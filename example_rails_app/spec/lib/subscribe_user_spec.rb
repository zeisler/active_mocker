require 'spec_helper'
require 'active_support/core_ext'
require 'lib/subscribe_user'
require 'spec/mocks/user_mock'
require 'spec/mocks/subscription_mock'

RSpec.describe SubscribeUser, active_mocker:true do

  let(:user){ User.create }

  subject{ described_class.new(user: user) }

  describe 'with_yearly' do
    it { subject.with_yearly }
  end

  describe 'with_monthly' do
    it { subject.with_monthly }
  end

end
