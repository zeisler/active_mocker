# frozen_string_literal: true

module ActiveMocker
  module Inspectable
    refine Pathname do
      def inspect
        "Pathname(#{to_s.inspect})"
      end
    end
  end
end
