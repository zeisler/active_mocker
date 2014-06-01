module ActiveMocker

module Collection

  class HasMany < Association

    include Queries

    def initialize(collection, foreign_key=nil, id=nil)
      super(collection)
      update_all("#{foreign_key}" => id) if !id.nil? && collection.first.respond_to?(:update)
    end

  end

end
end