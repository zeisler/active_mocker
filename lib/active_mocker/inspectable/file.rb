# frozen_string_literal: true

module ActiveMocker
  # rubocop:disable Style/MethodName
  module Inspectable
    refine Dir do
      def File
        "File.new(#{path.inspect})"
      end
    end
  end
end
