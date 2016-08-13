# frozen_string_literal: true
module ActiveMocker
  module Inspectable
    refine Time do
      def inspect
        strftime("Time.new(%Y, %-m, %-d, %-H, %-M, %-S, \"%:z\")")
      end
    end
  end
end
