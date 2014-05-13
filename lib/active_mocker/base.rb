module ActiveMocker
  class Base
    extend Config
    extend Forwardable
    @@_self = self
    def_delegators :@@_self,
                   :mass_assignment,
                   :schema_attributes,
                   :model_attributes,
                   :model_dir,
                   :schema_file,
                   :model_file_reader,
                   :schema_file_reader,
                   :clear_cache,
                   :migration_dir

    attr_reader :model_name, :klass

    def initialize(model_name)
      @model_name = model_name
      # active_hash_mock_class
      create_template
    end

    def self.configure(&block)
      config(&block)
    end

    def self.mock(model_name)
      self.send(:new, model_name).klass
    end

    def model_definition
      @model_definition ||= ModelReader.new({model_dir: model_dir, file_reader: model_file_reader}).parse(model_file_name)
    end

    def model_file_name
      model_name.tableize.singularize
    end

    def table_definition
      @table_definition ||= SchemaReader.new({schema_file: schema_file, file_reader: schema_file_reader, clear_cache: clear_cache, migration_dir: migration_dir}).search(model_name.tableize)
    end

    def create_template
      # require_relative '../../person_mock'
      start_time = Time.now
      # require_relative '../../plan_mock'
      # puts "require file: #{Time.now - start_time}"
      fields = table_definition.column_names
      mock_template = MockTemplate.new
      # Schema Attributes
      mock_template.attributes = fields
      mock_template.class_name = mock_class_name
      mock_template.attribute_names = table_definition.column_names
      mock_template.column_names = table_definition.column_names

      # Model associations
      mock_template.single_associations = model_definition.single_relationships
      mock_template.collection_associations = model_definition.collections
      mock_template.association_names = [*model_definition.single_relationships, *model_definition.collections]

      # Model Methods
      mock_template.instance_methods = instance_methods.methods
      mock_template.mock_instance_methods = instance_methods.mock_instance_methods
      mock_template.class_methods = class_methods.methods
      mock_template.mock_class_methods = class_methods.mock_class_methods

      klass_str = mock_template.render(File.open('lib/mock_template.erb').read)
      File.open("#{File.expand_path File.dirname(__FILE__)}/#{model_name.tableize.singularize}_mock.rb", 'w').write(klass_str)
      m = Module.new
      m.module_eval(klass_str,"#{File.expand_path File.dirname(__FILE__)}/#{model_name.tableize.singularize}_mock.rb")
      model = m.const_get m.constants.first
      puts "creating file: #{Time.now - start_time}"
      return @klass = Object.const_set(mock_class_name, Class.new(model)) unless class_exists? mock_class_name

      return @klass = mock_class_name.constantize if class_exists? mock_class_name
    end

    def active_hash_mock_class
      fill_templates
      add_method_mock_of
      if schema_attributes
        klass  = create_klass
        fields = table_definition.column_names
        klass.class_eval do
          klass.fields(*fields)
        end
        add_column_names_method
      end
      if model_attributes
        add_class_methods
        add_instance_methods
        add_single_relationships
        add_collections_relationships
      end
    end

    def fill_templates
      klass = create_klass
      klass.send(:association_names=, model_definition.relationships)
      klass.send(:attribute_names=, table_definition.column_names)
    end

    def add_method_mock_of
      klass = create_klass
      m_name = model_name
      klass.instance_variable_set(:@model_class, model_definition.klass)
      klass.instance_eval do
        define_method(:mock_of) {m_name}
      end
    end

    def add_single_relationships
      klass = create_klass
      model_definition.single_relationships.each do |m|
        klass.send(:association_template)[m] = nil
        create_association(m)
      end
    end

    def add_collections_relationships
      klass = create_klass
      model_definition.collections.each do |m|
        klass.send(:association_template)[m] = nil
        begin
          klass.class_eval <<-eos, __FILE__, __LINE__+1
             def #{m}
              read_association(#{m.inspect})
            end

            def #{m}=(value)
              write_association(#{m.inspect}, CollectionAssociation.new(value))
            end
          eos
        rescue SyntaxError
          Logger_.warn "ActiveMocker :: Can't create accessor methods for #{m}.\n #{caller}"
        end
      end
    end

    def create_association(m)
        begin
          klass.class_eval <<-eos, __FILE__, __LINE__+1
             def #{m}
              read_association(#{m.inspect})
            end

            def #{m}=(value)
              write_association(#{m.inspect}, value)
            end
          eos
        rescue SyntaxError
          Logger_.warn "ActiveMocker :: Can't create accessor methods for #{m}.\n #{caller}"
        end
    end


    def add_instance_methods
      klass = create_klass
      model_definition.instance_methods_with_arguments.each do |method|
        m = method.keys.first
        if m == :attributes
          Logger_.warn "ActiveMocker Depends on the #attributes method. It will not be redefined for the mock."
          next
        end
        params      = Reparameterize.call(method.values.first)
        params_pass = Reparameterize.call(method.values.first, true)

        klass.send(:model_methods_template)[m] = eval_lambda(params, %Q[raise "##{m} is not Implemented for Class: #{klass.name}"])
        klass.class_eval <<-eos, __FILE__, __LINE__+1
          def #{m}(#{params})
            block =  model_instance_methods[#{m.inspect}].to_proc
            instance_exec(*[#{params_pass}], &block)
          end
        eos
      end
    end

    def instance_methods
      mock_instance_methods = {}
      instance_methods = Methods.new
      instance_methods.methods = model_definition.instance_methods_with_arguments.map do |method|
        m = method.keys.first
        if m == :attributes
          Logger_.warn "ActiveMocker Depends on the #attributes method. It will not be redefined for the mock."
          next
        end
        params      = Reparameterize.call(method.values.first)
        params_pass = Reparameterize.call(method.values.first, true)

        instance_method = Method.new
        instance_method.method = m
        instance_method.params = params
        instance_method.params_pass = params_pass
        mock_instance_methods[m] = [params, %Q[raise "#{}#{m} is not Implemented for Class: #{mock_class_name}"]]
        instance_method
      end
      instance_methods.mock_instance_methods = mock_instance_methods
      instance_methods
    end

    class Method
      attr_accessor :method, :params, :params_pass
    end

    class Methods
      attr_accessor :methods, :mock_class_methods, :mock_instance_methods
    end

    def add_class_methods
      klass = create_klass
      model_definition.class_methods_with_arguments.each do |method|
        m = method.keys.first
        params = Reparameterize.call(method.values.first)
        params_pass = Reparameterize.call(method.values.first, true)
        klass.send(:model_class_methods)[m] = eval_lambda(params, %Q[raise "::#{m} is not Implemented for Class: #{klass.name}"])
        klass.class_eval <<-eos, __FILE__, __LINE__+1
          def self.#{m}(#{params})
            block =  model_class_methods[#{m.inspect}].to_proc
            instance_exec(*[#{params_pass}], &block)
          end
        eos
      end
    end

    def class_methods
      mock_class_methods = {}
      class_methods = Methods.new
      class_methods.methods = model_definition.class_methods_with_arguments.map do |method|
        m = method.keys.first
        params      = Reparameterize.call(method.values.first)
        params_pass = Reparameterize.call(method.values.first, true)

        class_method = Method.new
        class_method.method = m
        class_method.params = params
        class_method.params_pass = params_pass
        mock_class_methods[m] = [params, %Q[raise "#{}#{m} is not Implemented for Class: #{mock_class_name}"]]
        class_method
      end
      class_methods.mock_class_methods = mock_class_methods
      class_methods
    end

    def eval_lambda(arguments, block)
      eval(%Q[ ->(#{arguments}){ #{block} }],binding, __FILE__, __LINE__)
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
      klass = Object.const_set(mock_class_name, Class.new(::ActiveHash::Base))
      klass.send(:include, ActiveHash::ARApi)
      klass.send(:prepend, ModelInstanceMethods) # is a private method for ruby 2.0.0
      klass.extend ModelClassMethods
      klass
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

  module ModelInstanceMethods

    def mock_instance_method(method, &block)
      model_instance_methods[method] = block
    end

    def inspect
      inspection =  self.class.column_names.map { |name|
                         "#{name}: #{attribute_for_inspect(name)}"
                     }.compact.join(", ")

      "#<#{self.class} #{inspection}>"
    end

    def attribute_for_inspect(attr_name)
      value = self.attributes[attr_name]
      if value.is_a?(String) && value.length > 50
        "#{value[0, 50]}...".inspect
      elsif value.is_a?(Date) || value.is_a?(Time)
        %("#{value.to_s(:db)}")
      elsif value.is_a?(Array) && value.size > 10
        inspected = value.first(10).inspect
        %(#{inspected[0...-1]}, ...])
      else
        value.inspect
      end
    end

    def hash
      attributes.hash
    end

     def ==(obj)
      hash == obj.attributes.hash
    end

    private

    def read_attribute(attr)
      attributes[attr]
    end

    def write_attribute(attr, value)
      attributes[attr] = value
    end

    def read_association(attr)
      @associations[attr]
    end

    def write_association(attr, value)
      @associations[attr] = value
    end

    def attribute_to_string
      attributes.map {|k, v| "#{k.to_s}: #{v.inspect}"}.join(', ')
    end

    def delegate_to_model_instance(method, *args)
      self.class.send(:delegate_to_model_instance, method, *args)
    end

    def delegate_to_model_class(method, *args)
      self.class.send(:delegate_to_model_class, method, *args)
    end

    def model_instance_methods
      @model_instance_methods ||= self.class.send(:model_methods_template).dup
    end

    def schema_attributes
      @schema_attributes ||= self.class.send(:attribute_template).dup
    end

  end

  module ModelClassMethods

    def mock_instance_method(method, &block)
      model_methods_template[method] = block
    end

    def mock_class_method(method, &block)
      model_class_methods[method] = block
    end

    def column_names
      schema_attributes_template
    end

    private

    def delegate_to_model_instance(method, *args)
      model_class_instance.send(method, *args)
    end

    def delegate_to_model_class(method, *args)
      model_class.send(method, *args)
    end

    def model_class_methods
      @model_class_methods ||= HashWithIndifferentAccess.new
    end

    def model_methods_template
      @model_methods_template ||= HashWithIndifferentAccess.new
    end

    def schema_attributes_template
      @schema_attributes_template ||= HashWithIndifferentAccess.new
    end

    def model_class
      @model_class
    end

    def model_class_instance
      @model_class_instance ||= model_class.new
    end

    def attribute_names
      @attribute_names
    end

    def attribute_names=(attributes)
      @attribute_names = attributes.map{|a| a.to_sym}
    end

    def attribute_template
      return @attribute_template unless @attribute_template.nil?
      @attribute_template = HashWithIndifferentAccess.new
      attribute_names.each {|a| @attribute_template[a] = nil}
      return @attribute_template
    end

    def association_names
      @association_names
    end

    def association_names=(associations)
      @association_names = associations.map{|a| a.to_sym}
    end

    def association_template
      return @association_template unless @association_template.nil?
      @association_template = HashWithIndifferentAccess.new
      association_names.each {|a| @association_template[a] = nil}
      return @association_template
    end

  end

  class MockTemplate
    attr_accessor :attributes,
                  :single_associations,
                  :collection_associations,
                  :class_name,
                  :association_names,
                  :attribute_names,
                  :column_names,
                  :instance_methods,
                  :class_methods,
                  :mock_instance_methods,
                  :mock_class_methods

    def render(template)
      ERB.new(template,nil,true).result(binding)
    end
  end

end

