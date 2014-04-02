module ActiveMocker

  class Base
    extend Config
    extend Forwardable
    @@_self = self
    def_delegators :@@_self,
                   :mass_assignment,
                   :model_relationships,
                   :schema_attributes,
                   :model_methods,
                   :active_hash_as_base,
                   :model_dir,
                   :schema_file,
                   :model_file_reader,
                   :schema_file_reader

    attr_reader :model_name, :klass

    def initialize(model_name)
      @model_name = model_name
      plain_mock_class       unless active_hash_as_base
      active_hash_mock_class if active_hash_as_base
    end

    def self.configure(&block)
      config(&block)
    end

    def self.mock(model_name)
      self.new(model_name).klass
    end

    def model_definition
      return @model_definition unless @model_definition.nil?
      @model_definition = ModelReader.new({model_dir: model_dir, file_reader: model_file_reader}).parse(model_file_name)
    end

    def model_file_name
      model_name.tableize.singularize
    end

    def table_definition
      table_name = model_name.tableize
      table = SchemaReader.new({schema_file: schema_file, file_reader: schema_file_reader}).search(table_name)
      raise "#{table_name} table not found." if table.nil?
      return table
    end

    def active_hash_mock_class

      add_column_names_method
      klass  = create_klass
      fields = table_definition.column_names + model_definition.relationships
      klass.class_eval do
        klass.fields(*fields)
      end

      add_method_mock_of
      if model_methods
        add_instance_methods
        add_mock_instance_method
        add_mock_class_method
        add_class_methods
      end

    end

    def plain_mock_class
      add_method_mock_of
      if model_methods
        add_instance_methods
        add_mock_instance_method
        add_mock_class_method
        add_class_methods
      end
      add_relationships        if model_relationships
      add_column_names_method  if schema_attributes
      add_table_attributes     if schema_attributes
      create_initializer       if mass_assignment
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
        params      = Reparameterize.call(method.values.first)
        params_pass = Reparameterize.call(method.values.first, true)
        klass.instance_variable_set("@instance_#{m}", eval_lambda(params, %Q[raise "##{m} is not Implemented for Class: #{klass.name}"]))
        block = eval_lambda(params, %Q[ self.class.instance_variable_get("@instance_#{m}").call(#{params_pass})])
        klass.instance_eval do
          define_method(m, block)
        end
      end
    end

    def add_class_methods
      klass = create_klass
      model_definition.class_methods_with_arguments.each do |method|
        m = method.keys.first
        params = Reparameterize.call(method.values.first)
        params_pass = Reparameterize.call(method.values.first, true)
        klass.class_variable_set("@@klass_#{m}", eval_lambda(params, %Q[raise "::#{m} is not Implemented for Class: #{klass.name}"]))
        block = eval_lambda(params, %Q[ class_variable_get("@@klass_#{m}").call(#{params_pass})])
        klass.singleton_class.class_eval do
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
          klass.instance_variable_set("@instance_#{method.to_s}", block)
        end
      end
      klass.instance_eval do
        define_method(:mock_instance_method) do |method, &block|
          klass.instance_variable_set("@instance_#{method.to_s}", block)
        end
      end
    end

    def add_mock_class_method
      klass = create_klass
      klass.singleton_class.class_eval do
        define_method(:mock_class_method) do |method, &block|
          class_variable_set("@@klass_#{method.to_s}", block)
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
      return Object.const_set(mock_class_name ,Class.new(ActiveHash::Base)) if active_hash_as_base
      return Object.const_set(mock_class_name ,Class.new()) unless active_hash_as_base
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

