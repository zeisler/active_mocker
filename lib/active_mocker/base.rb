module ActiveMocker

  #TODO DRY up method creation
  #TODO have instance variable array for instance method
  #TODO have class variable array for class method
  #TODO enable support for active_hash as base class
  #TODO work on options interface

  class Base

    attr_reader :model_name,
                :model_options,
                :options_schema,
                :mass_assignment,
                :model_relationships,
                :schema_attributes,
                :model_methods

    def initialize(options={})
      @schema_attributes   = options.fetch(:schema_attributes,   true)
      @model_relationships = options.fetch(:model_relationships, true)
      @model_methods       = options.fetch(:model_methods,       true)
      @mass_assignment     = options.fetch(:mass_assignment,     true)
      @model_options       = options[:model]
      @options_schema      = options[:schema]
    end

    def mock(model_name)
      @model_name = model_name
      mock_class
    end

    def model_definition
      return @model_definition unless @model_definition.nil?
      @model_definition = ModelReader.new(model_options).parse(model_file_name)
    end

    def model_file_name
      model_name.tableize.singularize
    end

    def table_definition
      table_name = model_name.tableize
      table = SchemaReader.new(options_schema).search(table_name)
      raise "#{table_name} table not found." if table.nil?
      return table
    end

    def mock_class
      add_method_mock_of
      add_instance_methods     if model_methods
      add_mock_instance_method if model_methods
      add_relationships        if model_relationships
      add_class_methods        if model_methods
      add_column_names_method  if schema_attributes
      add_table_attributes     if schema_attributes
      create_initializer       if mass_assignment
      return @klass
    end

    def create_initializer
      klass = create_klass
      klass.instance_eval do
        define_method('initialize') do |options={}|
          options.each {|method, value| send("#{method}=", value)}
        end
      end
    end

    def add_relationships
      klass = create_klass
      model_definition.relationships.each do |m|
        klass.instance_variable_set("@#{m}", nil)
        klass.class_eval { attr_accessor m }
      end
    end

    def add_method_mock_of
      klass = create_klass
      klass.class_variable_set(:@@model_name, model_name)
      klass.instance_eval do
        define_method(:mock_of) {klass.class_variable_get :@@model_name}
      end
    end

    def add_table_attributes
      klass = create_klass
      table_definition.column_names.each do |m|
        klass.instance_variable_set("@#{m}", nil)
        klass.class_eval { attr_accessor m }
      end
    end

    def add_instance_methods
      klass = create_klass
      model_definition.instance_methods_with_arguments.each do |method|
        m = method.keys.first
        params = Reparameterize.call(method.values.first)
        params_pass = Reparameterize.call(method.values.first, true)
        klass.instance_variable_set("@#{m}", eval_lambda(params, %Q[raise "##{m} is not Implemented for Class: #{klass.name}"]))
        block = eval_lambda(params, %Q[ self.class.instance_variable_get("@#{m}").call(#{params_pass})])
        klass.instance_eval do
          define_method(m, block)
        end
      end
    end

    def eval_lambda(arguments, block)
      eval(%Q[ ->(#{arguments}){ #{block} }])
    end

    def add_mock_instance_method
      klass = create_klass
      klass.singleton_class.class_eval do
        define_method(:mock_instance_method) do |method, &block|
          klass.instance_variable_set("@#{method.to_s}", block)
        end
      end
    end

    def add_class_methods
      klass = create_klass
      model_definition.class_methods.each do |m|
        klass.singleton_class.class_eval do
          define_method(m) do
            raise "::#{m} is not Implemented for Class: #{klass.name}"
          end
        end
      end
    end

    def add_column_names_method
      klass = create_klass
      table = table_definition
      klass.singleton_class.class_eval do
        define_method(:column_names) do
          table.column_names
        end
      end
    end

    def create_klass
      @klass ||= const_class
    end

    def const_class
      remove_const(mock_class_name) if class_exists? mock_class_name
      return Object.const_set(mock_class_name, Class.new) unless Object.const_defined?(mock_class_name)
      return Object.const_get(mock_class_name, false)
    end

    def remove_const(class_name)
      Object.send(:remove_const, class_name)
    end

    def class_exists?(class_name)
      klass = Module.const_get(class_name)
      return klass.is_a?(Class)
      rescue NameError
        return false
    end

    def mock_class_name
      "#{model_name}Mock"
    end

  end

end

