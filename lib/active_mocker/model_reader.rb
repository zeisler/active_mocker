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
      self
    end

    def klass
      @klass ||= eval_file
    end

    def eval_file
      failure = true
      while failure
        begin
          m = Module.new
          m.module_eval(read_file, file_path)
        rescue NameError => e
          raise e
          result = e.to_s.scan /::(\w*)$/ # gets the Constant name from error
          const_name = result.flatten.first
          Logger_.debug "ActiveMocker :: Can't can't find Constant #{const_name} from class #{model_name}..\n #{caller}"
          next
        end
        failure = false
        model = m.const_get m.constants.first
      end
      model
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

  end

end

