# frozen_string_literal: true

module ActiveMocker
  module Inspectable
    refine Struct do
      def inspect
        format("%s.new(%s)", self.class.name, values.map(&:inspectable).join(", "))
      end
    end
  end
end
