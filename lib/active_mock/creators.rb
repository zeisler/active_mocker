module ActiveMock
    module Creators

      def create(attributes = {}, &block)
        record = new
        record.save
        record.send(:set_properties, attributes) unless block_given?
        record.send(:set_properties_block, attributes, &block) if block_given?
        record
      end

      alias_method :create!, :create

      def find_or_create_by(attributes)
        find_by(attributes) || create(attributes)
      end

      def find_or_initialize_by(attributes)
        find_by(attributes) || new(attributes)
      end

    end

end

