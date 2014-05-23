module ActiveMocker
module Collection

  module Queries

    def delete_all
      all.map(&:delete)
    end

    def all(options={})
      if options.has_key?(:conditions)
        where(options[:conditions])
      else
        ActiveMocker::Collection::Base.new( to_a || [] )
      end
    end

    def where(options)
      return all if options.nil?
      all.select do |record|
        options.all? { |col, match| record[col] == match }
      end
    end

  end

end
end

