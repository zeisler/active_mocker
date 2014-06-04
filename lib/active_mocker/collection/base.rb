module ActiveMocker

  module Collection


    class Base

      include Enumerable

      def initialize(collection=[])
        @collection = [*collection]
      end

      def <<(*records)
        collection.concat(records.flatten)
      end

      delegate :take, :push, :clear, :first, :last, :concat, :replace, :distinct, :uniq, :count, :size, :length, :empty?, :any?, :include?, :delete, to: :collection
      alias distinct uniq

      # def delete(obj)
      #   collection.delete(obj)
      # end

      def order(key)
        self.collection = collection.sort_by{ |item| item.send(key) }
        self
      end

      def reverse_order
        self.collection = collection.reverse
        self
      end

      def select(&block)
        self.collection = collection.select(&block)
        self
      end

      def each(&block)
        self.collection = collection.each do |item|
          block.call(item)
        end
        self
      end

      def to_a
        @collection
      end

      def ==(val)
        return false if val.nil?
        collection.hash == val.hash
      end

      protected

      def collection
        @collection
      end

      attr_writer :collection

    end

  end




end