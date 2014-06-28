module ActiveMocker
  module Mock
    class HashProcess

      attr_accessor :hash, :processor

      def initialize(hash, processor)
        @hash         = hash
        @processor    = processor
        @hash_process = {}
      end

      def [](val)
        @hash_process[val] ||= processor.call(hash[val])
      end

    end
  end
end