# frozen_string_literal: true

module ActiveMocker
  module Queries
    class Find
      def initialize(record)
        @record = record
      end

      def is_of(conditions = {})
        conditions.all? do |col, match|
          if match.is_a? Enumerable
            any_match(col, match)
          else
            compare(col, match)
          end
        end
      end

      private

      def any_match(col, match)
        match.any? { |m| compare(col, m) }
      end

      def compare(col, match)
        @record.send(col) == match
      end
    end
  end
end
