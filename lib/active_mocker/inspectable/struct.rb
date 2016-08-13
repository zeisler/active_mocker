# frozen_string_literal: true
module ActiveMocker
  module Inspectable
    refine Struct do
      def inspect
        "%s.new(%s)" % [self.class.name, values.map(&:inspectable).join(", ")]
      end
    end
  end
end
