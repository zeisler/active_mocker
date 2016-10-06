module ActiveMocker
  class LoadedMocks
    class Features
      include Singleton
      DEFAULTS = { timestamps: false }.freeze

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
