# frozen_string_literal: true

module ActiveMocker
  module Inspectable
    refine Date do
      def inspect
        format("Date.new(%s, %s, %s)", year, month, day)
      end
    end

    refine DateTime do
      def inspect
        strftime("DateTime.new(%Y, %-m, %-d, %-H, %-M, %-S, \"%:z\")")
      end
    end
  end
end
