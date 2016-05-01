# frozen_string_literal: true
module ActiveMocker
  module Rspec
    # @return ActiveMocker::LoadedMocks
    def active_mocker
      ActiveMocker::LoadedMocks
    end
  end
end
