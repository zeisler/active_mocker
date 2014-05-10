module ActiveMocker

  class Table

    attr_reader :name, :fields

    def initialize(name, fields=[])
      @name   = name
      @fields = fields
      fields.unshift Field.new('id', :integer, {})
    end

    def to_h
      {name: name, fields: fields.to_h}
    end

    alias_method :to_hash, :to_h

    def column_names
      fields.map { |f| f.name }
    end

  end

end