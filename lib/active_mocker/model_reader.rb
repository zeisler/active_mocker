module ActiveMocker

  class ModelReader

    attr_reader :model_name, :relative_path

    def initialize(model_name, relative_path='')
      @model_name = model_name
      @relative_path = relative_path
    end

    def klass
      @klass ||= eval_file
    end

    def eval_file
      m = Module.new
      m.module_eval(read_file)
      m.const_get m.constants.first
    end

    def read_file
      File.open("#{relative_path}/#{model_name}.rb").read
    end

    def class_methods
      (klass.methods - Object.methods - instance_methods - ActiveRecord::Base.methods) + klass.public_class_methods
    end

    def instance_methods
      klass.public_instance_methods(false)
    end

    def relationships
      klass.relationships
    end

  end

end

