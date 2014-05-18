module ActiveMocker

  class Field

    attr_accessor :name, :type, :options

    def initialize(name, type, options)
      @name    = name
      @type    = type
      @options = {}
      options.each{|hash| @options[hash.keys.first] = hash.values.first}
      create_option_methods
    end

    def to_h
      {name: name, type: type, options: options}
    end

    alias_method :to_hash, :to_h

    def create_option_methods
      options.each do |key, value|
        self.instance_variable_set("@#{key}", value)
        self.class.send(:attr_accessor, key)
      end
    end

  end

end
