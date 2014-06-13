module ActiveMock
    module Creators

      def create(attributes = {}, &block)
        record = new({id: attributes.symbolize_keys[:id]})
        record.save
        record.update(attributes) unless block_given?
        record.update(attributes, &block) if block_given?
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

