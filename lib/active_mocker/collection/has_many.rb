module ActiveMocker

module Collection

  class HasMany < Association

    include Queries

    def initialize(foreign_key, id,  collection)
      super(collection)
      update_all("#{foreign_key}" => id) if collection.first.respond_to?(:update)
    end

  end

end
end