module ActiveMocker

  class Base

    attr_reader :model_definition, :model_name

    def initialize(model_name, relative_path='')
      @model_definition = ModelReader.new(model_name.tableize.singularize , relative_path)
      @model_definition.klass
      @model_name = model_name
    end

    def mock_class
      add_method_mock_of
      add_instance_methods
      add_class_methods
      create_klass
    end

    def add_method_mock_of
      klass = create_klass
      klass.class_variable_set(:@@model_name, model_name)
      klass.instance_eval do
        define_method(:mock_of) {klass.class_variable_get :@@model_name}
      end
    end

    def add_instance_methods
      klass = create_klass
      model_definition.instance_methods.each do |m|
        klass.instance_eval do
          define_method(m) {raise "##{m} is not Implemented for Class: #{klass.name}"}
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

    def create_klass
      @klass ||= const_class
    end

    def const_class
      return Object.const_set(mock_class_name, Class.new) unless Object.const_defined?(mock_class_name)
      return Object.const_get(mock_class_name, false)
    end

    def mock_class_name
      "#{model_name}Mock"
    end

  end

end

