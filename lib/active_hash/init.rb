
module ActiveHash
  module ARApi

    module Init

      attr_reader :associations, :types

      def initialize(attributes = {}, &block)
        @types = {}
        @associations = {}
        yield self if block_given?
        attributes.each do |key, value|
          begin
            send "#{key}=", value
          rescue NoMethodError
            raise ActiveMocker::RejectedParams, "{:#{key}=>#{value.inspect}} for #{self.class.name}"
          end
        end

      end



    end
  end

end

module ActiveMocker
  class RejectedParams < Exception
  end
end