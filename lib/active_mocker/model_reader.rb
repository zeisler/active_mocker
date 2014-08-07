
module ActiveMocker
  # @api private

  class ModelReader

    attr_reader :model_name, :model_dir, :file_reader

    def initialize(options={})
      @file_reader = options[:file_reader] ||= FileReader
      @model_dir   = options[:model_dir]
    end

    def parse(model_name)
      @model_name = model_name
      klass
      return self if @klass
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
          _klass = m.const_get(m.constants.last)
        rescue SyntaxError => e
          log_loading_error(e, true)
          failure = true
        rescue Exception => e
          log_loading_error(e, false)
          failure = true
        end

      return false if _klass.nil? || failure

      if _klass.superclass != ActiveMocker::ActiveRecord::Base
        log_loading_error("Single Table inheritance not supported yet.\n\tFor more info: https://github.com/zeisler/active_mocker/issues/10", true)
        return false
      end
       _klass
    end

    def log_loading_error(msg, print_to_stdout=false)
      main = "ActiveMocker :: Error loading Model: #{model_name} \n\t#{msg}\n"
      file = "\t#{file_path}\n"
      Logger.error main + file
      print main + file if print_to_stdout
    end

    def real
      model_name.classify.constantize
    end

    def read_file(m_name=model_name)
      file_reader.read(file_path(m_name))
    end

    def file_path(m_name=model_name)
      "#{model_dir}/#{m_name}.rb"
    end

    def class_methods
      klass.methods(false)
    end

    def scopes
      klass.get_named_scopes
    end

    def scopes_with_arguments
      scopes.map do |name, proc|
        {name => proc.parameters, :proc => proc}
      end
    end

    def class_methods_with_arguments
      class_methods.map do |m|
        {m => klass.method(m).parameters }
      end
    end

    def instance_methods_with_arguments
      instance_methods.map do |m|
        {m => klass.instance_method(m).parameters }
      end
    end

    def instance_methods
      methods = klass.public_instance_methods(false)
      methods << klass.superclass.public_instance_methods(false) if klass.superclass != ActiveRecord::Base
      methods.flatten
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

    def modules
      {included:  process_module_names(klass._included),
       extended: process_module_names(klass._extended)}
    end

    def process_module_names(names)
      names.reject { |m| /#{klass.inspect}/ =~ m.name }.map(&:inspect)
    end

  end

end

