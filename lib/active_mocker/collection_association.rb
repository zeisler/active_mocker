module ActiveMocker

  class CollectionAssociation

    def initialize(collection=[])
      @association = [*collection]
    end

    def <<(*records)
      association.concat(records.flatten)
    end

    delegate :any?, :empty?, :length, :size, :count, :uniq, :replace, :first, :last, :concat, :include?, :push, :clear, :take, to: :association
    alias distinct uniq

    def sum(attribute=nil)
      values = association.map { |obj| obj.send(attribute) }
      values.inject { |sum, n| sum + n }
    end

    def ==(other_ary)
      association == other_ary
    end

    def to_a
      @association
    end

    private
    attr_accessor :association

  end
end
