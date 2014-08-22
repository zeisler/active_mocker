module ActiveMocker
  module ActiveRecord
  # @api private
  class Field

    attr_accessor :name, :type, :options

    def initialize(name, type, options)
      @name    = name
      @type    = type
      @primary_key
      @options = options.first || {}
    end

    def primary_key
      @primary_key
    end

    def to_h
      {name: name, type: type, options: options}
    end

    alias_method :to_hash, :to_h

    def default
      options[:default]
    end

    def precision
      options[:precision]
    end

    def scale
      options[:scale]
    end

  end
  end
end
