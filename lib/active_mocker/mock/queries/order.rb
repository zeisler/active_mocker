# frozen_string_literal: true

module ActiveMocker
  module Queries
    # @private
    # rubocop:disable Naming/UncommunicativeMethodParamName
    module Order
      class << self
        def call(args, all)
          options = args.extract_options!
          if options.empty? && args.count == 1
            all.sort_by { |item| item.send(args.first) }
          else
            order_mixed_args(all, args, options)
          end
        end

        private

        def order_mixed_args(all, args, options)
          normalized_opt = normalized_opt(args, options) # Add non specified direction keys
          all.sort { |a, b| build_order(a, normalized_opt) <=> build_order(b, normalized_opt) }
        end

        def normalized_opt(args, options)
          args.each_with_object({}) { |a, h| h[a] = :asc }.merge(options)
        end

        def build_order(a, options)
          options.map { |k, v| send(v, a.send(k)) }
        end

        def desc(r)
          DESC.new(r)
        end

        def asc(r)
          r
        end
      end

      class DESC
        attr_reader :r

        def initialize(r)
          @r = r
        end

        def <=>(other)
          -(r <=> other.r) # Flip negative/positive result
        end
      end
    end
  end
end
