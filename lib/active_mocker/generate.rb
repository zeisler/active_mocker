module ActiveMocker
class Generate
  extend Config
  extend Forwardable

  @@_self = self
  def_delegators :@@_self,
                 :schema_attributes,
                 :model_attributes,
                 :model_dir,
                 :schema_file,
                 :model_file_reader,
                 :schema_file_reader,
                 :mock_dir,
                 :logger

  def initialize
    create_template
  end

  def self.configure(&block)
    config(&block)
  end

  def self.mock(model_name, force_reload: false)
    load_mock(model_name)
  end

  def self.load_mock(model_name)
    load File.join(mock_dir, "#{model_name.tableize.singularize}_mock.rb")
    "#{model_name}Mock".constantize
  end

  def model_definition(table)
    return @model_definition if @model_definition_table == table
    @model_definition_table = table
    @model_definition       = ModelReader.new({model_dir: model_dir, file_reader: model_file_reader}).parse(table_to_model_file(table))
  end

  def table_to_model_file(table)
    table.singularize
  end

  def table_to_class_name(table)
    table.camelize.singularize
  end

  def schema_reader
    SchemaReader.new({schema_file: schema_file, file_reader: schema_file_reader}).search(nil)
  end

  def tables
    schema_reader
  end

  def create_template
    mocks_created = 0
    tables.each do |table|
      begin
      mock_template = MockTemplate.new
      # Schema Attributes
      mock_template.class_name      = mock_class_name(table.name)
      mock_template.attribute_names = table.column_names
      mock_template.attributes      = field_type_to_class(table.fields)
      mock_template.default_attributes = default_attr_values(table.fields)

      # Model associations
      # mock_template.single_associations     = model_definition(table.name).single_relationships
      # mock_template.collection_associations = model_definition(table.name).collections
      # association_names_array = [*model_definition(table.name).single_relationships.map(&:name), *model_definition(table.name).collections.map(&:name)]
      # mock_template.association_names  = {}
      # association_names_array.map do |a|
      #   next if a.nil?
      #   mock_template.association_names[a] = nil
      # end
      # raise 'error blank element' if model_definition(table.name).belongs_to.first.name.nil?
      mock_template.belongs_to = model_definition(table.name).belongs_to
      mock_template.has_one = model_definition(table.name).has_one
      mock_template.has_many = model_definition(table.name).has_many
      mock_template.has_and_belongs_to_many = model_definition(table.name).has_and_belongs_to_many

      # Model Methods
      mock_template.instance_methods       = instance_methods(table.name).methods
      mock_template.model_instance_methods = instance_methods(table.name).model_instance_methods
      mock_template.class_methods          = class_methods(table.name).methods
      mock_template.model_class_methods    = class_methods(table.name).model_class_methods

      klass_str = mock_template.render( File.open(File.join(File.expand_path('../', __FILE__), 'mock_template.erb')).read)
      FileUtils::mkdir_p mock_dir unless File.directory? mock_dir
      File.open(File.join(mock_dir,"#{table.name.singularize}_mock.rb"), 'w').write(klass_str)
      logger.info "saving mock #{table_to_model_file(table.name)} to #{mock_dir}"

      rescue Exception => exception
        logger.debug $!.backtrace
        logger.debug exception
        logger.info "failed to load #{table_to_model_file(table.name)} model"
        next
      end
      mocks_created += 1

    end
    logger.info "Generated #{mocks_created} of #{tables.count} mocks"
  end

  def field_type_to_class(fields)
    fields.map do |field|
      field.type = case field.type
         when :integer then
           Fixnum
         when :float then
           Float
         when :decimal then
           BigDecimal
         when :timestamp, :time then
           Time
         when :datetime then
           DateTime
         when :date then
           Date
         when :text, :string, :binary then
           String
         when :boolean then
           ::Virtus::Attribute::Boolean
       end
      field
    end

  end

  def mock_class_name(table_name)
    "#{table_to_class_name(table_name)}Mock"
  end

  def associations(names)
    hash = {}
    names.each do |name|
      hash[name] = nil
    end
    hash
  end

  def default_attr_values(fields)
    attributes = {}
    fields.each do |f|
      if f.options[:default].nil?
        attributes[f.name] = nil
      else
        value = f.default.class == String ? f.default : f.default
        attributes[f.name] = value
      end
    end
    attributes
  end

  def instance_methods(table_name)
    model_instance_methods = []
    instance_methods = Methods.new
    instance_methods.methods = model_definition(table_name).instance_methods_with_arguments.map do |method|
      m = method.keys.first.to_s
      if m == :attributes
        logger.warn "ActiveMocker Depends on the #attributes method. It will not be redefined for the model."
        next
      end
      params      = Reparameterize.call(method.values.first)
      params_pass = Reparameterize.call(method.values.first, true)

      instance_method = Method.new
      instance_method.method = m
      instance_method.params = params

      instance_method.params_pass = params_pass
      model_instance_methods << m
      instance_method
    end
    instance_methods.model_instance_methods = {}
    model_instance_methods.each{|meth| instance_methods.model_instance_methods[meth] = :not_implemented }
    instance_methods
  end

  def class_methods(table_name)
    model_class_methods = []
    class_methods = Methods.new
    class_methods.methods = model_definition(table_name).class_methods_with_arguments.map do |method|
      m = method.keys.first.to_s
      params      = Reparameterize.call(method.values.first)
      params_pass = Reparameterize.call(method.values.first, true)

      class_method = Method.new
      class_method.method = m
      class_method.params = params
      class_method.params_pass = params_pass
      model_class_methods << m
      class_method
    end
    class_methods.model_class_methods = {}
    model_class_methods.each { |meth| class_methods.model_class_methods[meth] = :not_implemented }
    class_methods
  end

  class Method
    attr_accessor :method, :params, :params_pass
  end

  class Methods
    attr_accessor :methods, :model_class_methods, :model_instance_methods
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
                  :model_instance_methods,
                  :model_class_methods,
                  :default_attributes,
                  :associations,

                  :belongs_to,
                  :has_one,
                  :has_many,
                  :has_and_belongs_to_many




    def render(template)
      ERB.new(template, nil, '-').result(binding)
    end
  end


end
end


