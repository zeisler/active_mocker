# frozen_string_literal: true
module ActiveMocker
  module Queries
    module AR52
      extend LateInclusion::Extension

      private

      def check_for_limit_scope!
        # noop
      end
    end
  end
end
