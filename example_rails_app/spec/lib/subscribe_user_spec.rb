require 'spec_helper'
require 'lib/subscribe_user'
require 'spec/mocks/user_mock'
require 'spec/mocks/subscription_mock'

RSpec.describe SubscribeUser, active_mocker: true do
  let(:user) { User.create }

  subject { described_class.new(user: user) }

  describe 'with_yearly' do
    it do
      subject.with_yearly
      expect(
          Subscription.where(user: user,
                             kind: 'yearly').count
      ).to eq 1
    end
  end

  describe 'with_monthly' do
    it do
      subject.with_monthly
      expect(Subscription.where(user: user, kind: 'monthly').count).to eq 1
    end
  end
end
