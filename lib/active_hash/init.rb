
module ActiveHash
  module ARApi

    module Init

      attr_reader :associations, :types

      def initialize(attributes = {}, &block)
        @types = {}
        @associations = {}
        yield self if block_given?
        update(attributes)
      end



    end
  end

end

module ActiveMocker
  class RejectedParams < Exception
  end
end