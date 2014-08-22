module ActiveMocker
  module ActiveRecord
  # @api private
  class Table

    attr_reader :name, :fields

    def initialize(name, id=true, fields=[])
      @name   = name
      @fields = fields
      fields.unshift Field.new('id', :integer, [{primary_key: true}]) if id.nil?
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
end