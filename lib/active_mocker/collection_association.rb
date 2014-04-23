module ActiveMocker

  class CollectionAssociation

    include Enumerable

    attr_accessor :collection

    def initialize(collection=[])
      @collection = *collection ||=[]
    end

    def each(&block)
      collection.each do |item|
        block.call(item)
      end
    end

    def last
      collection.last
    end

    def <<(*records)
      collection.concat(records.flatten)
    end

    def sum(attribute=nil)
      values = collection.map{ |obj| obj.send(attribute) }
      values.inject{ |sum, n| sum + n }
    end

    def ==(other_ary)
      collection == other_ary
    end

  end
end

