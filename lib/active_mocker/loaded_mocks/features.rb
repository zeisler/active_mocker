# frozen_string_literal: true
require "singleton"
require "active_mocker/mock/exceptions"

module ActiveMocker
  class LoadedMocks
    class Features
      include Singleton
      STUB_ACTIVE_RECORD_EXCEPTIONS = {
        "ActiveRecord::RecordNotFound"        => ActiveMocker::RecordNotFound,
        "ActiveRecord::RecordNotUnique"       => ActiveMocker::RecordNotUnique,
        "ActiveRecord::UnknownAttributeError" => ActiveMocker::UnknownAttributeError,
      }
      DEFAULTS                      = {
        timestamps:                    false,
        delete_all_before_example:     false,
        stub_active_record_exceptions: STUB_ACTIVE_RECORD_EXCEPTIONS,
      }.freeze

      def initialize
        reset
      end

      def each(&block)
        @features.each(&block)
      end

      def enable(feature)
        update(feature, true)
      end

      def disable(feature)
        update(feature, false)
      end

      def [](feature)
        @features[feature]
      end

      def reset
        @features = DEFAULTS.dup
      end

      def to_h
        @features
      end

      private

      def update(feature, value)
        if @features.key?(feature)
          @features[feature] = value
        else
          raise KeyError, "#{feature} is not an available feature."
        end
      end
    end
  end
end
