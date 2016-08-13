# frozen_string_literal: true
module ActiveMocker
  module Inspectable
    refine BigDecimal do
      def inspect
        "BigDecimal(\"%s\")" % to_s('F')
      end
    end
  end
end
