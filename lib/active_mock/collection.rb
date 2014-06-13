module ActiveMock

  class Collection

    include Enumerable

    def initialize(collection=[])
      @collection = [*collection]
    end

    def <<(*records)
      collection.concat(records.flatten)
    end

    extend Forwardable
    def_delegators :@collection, :take, :push, :clear, :first, :last, :concat, :replace, :distinct, :uniq, :count, :size, :length, :empty?, :any?, :include?, :delete
    alias distinct uniq

    def select(&block)
      collection.select(&block)
    end

    def each(&block)
      collection.each do |item|
        block.call(item)
      end
    end

    def map(&block)
      collection.map do |item|
        block.call(item)
      end
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