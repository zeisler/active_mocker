module ActiveMocker

  module Collection

    class Base

      include Enumerable

      def initialize(collection=[])
        @association = [*collection]
      end

      def <<(*records)
        association.concat(records.flatten)
      end

      delegate :<<, :take, :push, :clear, :first, :last, :concat, :replace, :distinct, :uniq, :count, :size, :length, :empty?, :any?, :include?, to: :association
      alias distinct uniq

      def delete(obj)
        association.delete(obj)
      end

      def order(key)
        self.sort_by{ |item| item.send(key) }
      end

      def select(&block)
        self.class.new(association.select(&block))
      end

      def sum(attribute=nil)
        values = association.map { |obj| obj.send(attribute) }
        values.inject { |sum, n| sum + n }
      end

      def ==(other_ary)
        association == other_ary
      end

      def each(&block)
        association.each do |item|
          block.call(item)
        end
      end

      def to_a
        @association
      end

      private
      attr_accessor :association

    end

  end

end