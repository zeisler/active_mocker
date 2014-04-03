module ActiveMocker

  class Field

    attr_reader :name, :type, :options

    def initialize(name, type, options)
      @name    = name
      @type    = type
      @options = options
      create_option_methods
    end

    def to_h
      {name: name, type: type, options: options}
    end

    def create_option_methods
      options.each do |opt|
        key, value = opt.first
        self.instance_variable_set("@#{key}", value)
        define_singleton_method(key) {instance_variable_get("@#{key}")}
      end
    end

  end

end
