module ActiveMocker

  class ModelReader

    attr_reader :model_name, :model_dir, :file_reader

    def initialize(options={})
      @file_reader = options[:file_reader] ||= FileReader
      @model_dir   = options[:model_dir]
    end

    def parse(model_name)
      @model_name = model_name
      klass
      return self unless @klass == false
      return false
    end

    def klass
      @klass ||= eval_file
    end

    def eval_file
      failure = false
        begin
          m = Module.new
          m.module_eval(read_file, file_path)
        rescue Exception => e
          Logger.error "ActiveMocker :: Error loading Model: #{model_name} \n \t\t\t\t\t\t\t\t`#{e}` \n"
          Logger.error "\t\t\t\t\t\t\t\t #{file_path}\n"
          failure = true
        end
      return m.const_get m.constants.first unless failure
      return false
    end

    def read_file
      file_reader.read(file_path)
    end

    def file_path
      "#{model_dir}/#{model_name}.rb"
    end

    def class_methods
      klass.methods(false)
    end

    def class_methods_with_arguments
      class_methods.map do |m|
        {m => klass.method(m).parameters }
      end
    end

    def instance_methods_with_arguments
      instance_methods.map do |m|
        {m => klass.new.method(m).parameters }
      end
    end

    def instance_methods
      klass.public_instance_methods(false)
    end

    def relationships_types
      klass.relationships
    end

    def relationships
      relationships_types.to_h.values.flatten
    end

    def collections
      klass.collections.flatten.compact
    end

    def single_relationships
      klass.single_relationships.flatten.compact
    end

    def belongs_to
      klass.relationships.belongs_to
    end

    def has_one
      klass.relationships.has_one
    end

    def has_and_belongs_to_many
      klass.relationships.has_and_belongs_to_many
    end

    def has_many
      klass.relationships.has_many
    end

    def table_name
      klass.table_name
    end

    def primary_key
      klass.primary_key
    end

    def constants
      const = {}
      klass.constants.each {|c| const[c] = klass.const_get(c)}
      const = const.reject do |c, v|
        v.class == Module || v.class == Class
      end
      const
    end

  end

end

