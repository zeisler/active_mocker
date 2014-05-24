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

      delegate :<<, :take, :push, :clear, :first, :last, :concat, :replace, :distinct, :uniq, :count, :size, :length, :empty?, :any?, :include?, :delete, to: :collection
      alias distinct uniq

      # def delete(obj)
      #   collection.delete(obj)
      # end

      def order(key)
        self.class.new(collection.sort_by{ |item| item.send(key) })
      end

      def reverse_order
        self.class.new(collection.reverse)
      end

      def select(&block)
        self.class.new(collection.select(&block))
      end

      def each(&block)
        self.class.new(collection.each do |item|
          block.call(item)
        end)
      end

      def to_a
        @collection
      end

      def ==(val)
        return false if val.nil?
        collection.hash == val.hash
      end

      private

      def collection
        @collection
      end

    end

  end




end