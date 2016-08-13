# frozen_string_literal: true
module ActiveMocker
  module Inspectable
    refine Dir do
      def inspect
        "Dir.new(#{path.inspect})"
      end
    end
  end
end
