# frozen_string_literal: true
module ActiveMocker
  class Relation < Collection
    include Queries
    include MockableMethod

    def initialize(collection = [])
      super
      @from_limit = false
    end

    def inspect
      entries     = to_a.take(11).map!(&:inspect)
      entries[10] = "..." if entries.size == 11
      "#<#{name} [#{entries.join(", ")}]>"
    end

    def from_limit?
      @from_limit
    end

    def name
      self.class.name
    end

    private

    def set_from_limit
      @from_limit = true
    end
  end
end
