module ActiveMocker
  # @api private
  module LoggerToJson

    def initialize(*args)
      super(args)
      UnitLogger.unit.info "#{caller_locations[1]}\n"
      obj = JSON.parse(self.to_hash.to_json)
      UnitLogger.unit.info "#{self.class.name}: #{JSON.pretty_unparse(obj)}\n"
      puts "#{self.class.name}: #{JSON.pretty_unparse(obj)}\n"
    end

  end

  # @api private
  class ModelSchemaCollection

    include Enumerable

    attr_accessor :collection

    def initialize(collection)
      @collection = collection
    end

    def each(&block)
      collection.each do |item|
        block.call(item)
      end
    end

    def find_by(options={})
      collection.select{|c| c.send(options.keys.first) == options.values.first}.first
    end

    def find_by_in_relationships(options={})
      result = nil
      collection.each do |item|
        result = item.relationships.select do |attr|
          attr.send(options.keys.first) == options.values.first
        end
      end
      result
    end


    def [](val)
      collection[val]
    end

  end

  class ModelSchema < AttrPermit
    attr_permit :class_name,
                :table_name,
                :attributes,
                :relationships,
                :_methods,
                :modules,
                :constants,
                :parent_class,
                :abstract_class

    def abstract_class
      !!call_method(:abstract_class)
    end

    def constants
      call_method(:constants) || []
    end

    def has_many
      relation_find(:type, :has_many)
    end

    def has_one
      relation_find(:type, :has_one)
    end

    def belongs_to
      relation_find(:type, :belongs_to)
    end

    def has_and_belongs_to_many
      relation_find(:type, :has_and_belongs_to_many)
    end

    def belongs_to_foreign_key(foreign_key)
      belongs_to.select { |r| r.foreign_key.to_sym == foreign_key.to_sym }.first
    end

    def relation_find(key, value)
      relationships.select { |r| r.send(key).to_sym == value }
    end

    def instance_methods
      method_find(:instance)
    end

    def class_methods
      method_find(:class)
    end

    def scope_methods
      method_find(:scope)
    end

    def methods
      call_method(:_methods) || []
    end

    def method_find(type)
      return [] if methods.nil?
      methods.select { |r| r.type.to_sym == type }
    end

    def attribute_names
      attributes.map(&:name)
    end

    def types_hash
      types = {}
      attributes.each do |attr|
        types[attr.name] = "#{attr.ruby_type}"
      end

      type_array = types.map do |name, type|
        "#{name}: #{type}"
      end
      '{ ' + type_array.join(', ') + ' }'
    end

    def attributes_with_defaults
      hash = {}
      attributes.each do |attr|
        hash[attr.name] = attr.default_value
      end
      hash
    end

    def associations
      hash = {}
      relationships.each do |r|
        hash[r.name] = nil
      end
      hash
    end

    def associations_by_class
      hash = {}
      relationships.each do |r|
        hash[r.class_name] ||= {}
        hash[r.class_name][r.type] ||= []
        hash[r.class_name][r.type] << r.name
      end
      hash
    end

    def mock_name(klass_name)
      klass_name + "Mock"
    end

    def mockable_class_methods
      class_methods.map(&:name).each_with_object({}) { |val, hash| hash[val] = nil }
    end

    def mockable_instance_methods
      instance_methods.map(&:name).each_with_object({}) { |val, hash| hash[val] = nil }
    end

    def parent_class
      return mock_name(call_method(:parent_class)) if call_method(:parent_class).present?
      'ActiveMocker::Mock::Base'
    end

    def is_child_class?
      call_method(:parent_class).present?
    end

    def render(template, mock_append_name)
      @mock_append_name = mock_append_name
      ERB.new(template, nil, '-').result(binding)
    end

    private :relation_find

    def primary_key
      key_attribute = attributes.select { |attr| attr.primary_key }.first
      return key_attribute if key_attribute
      default_primary_key
    end

    def default_primary_key
      default_id = Attributes.new(name: 'id', primary_key: true, type: :integer)
      call_method(:attributes).unshift(default_id)
      default_id
    end

    class Attributes

      attr_reader :name, :type, :precision, :scale, :default_value, :primary_key
      attr_writer :primary_key
      def initialize(name:,
                     type:,
                     precision:     nil,
                     scale:         nil,
                     default_value: nil,
                     primary_key:   nil
      )
        @name          = name
        @type          = type
        @precision     = precision     unless precision.nil?
        @scale         = scale         unless scale.nil?
        @default_value = default_value unless default_value.nil?
        @primary_key   = primary_key   unless primary_key.nil?
      end

      def ruby_type
        ActiveMocker::DBToRubyType.call(type)
      end

    end

    class Relationships

      attr_reader :name, :class_name, :type, :through, :source, :foreign_key, :join_table

      def initialize(name:,
          class_name:,
          type:,
          through:,
          source:,
          foreign_key:,
          join_table:
      )
        @name        = name
        @class_name  = class_name
        @type        = type
        @through     = through
        @source      = source
        @foreign_key = foreign_key
        @join_table  = join_table
      end

    end

    class Methods < AttrPermit

      attr_permit :name, :arguments, :type

      def arguments
        Arguments.new(call_method(:arguments))
      end

      class Arguments

        attr_reader :arguments

        def initialize(arguments)
          @arguments = arguments
        end

        def to_hash
          @arguments
        end

        def empty?
          @arguments.empty?
        end

        def to_s
          Reparameterize.method_arguments(arguments)
        end

        def passable
          Reparameterize.method_parameters(arguments)
        end

      end

    end

  end

end