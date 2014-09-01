module ActiveMocker
  # @api private

  class ModelReader

    attr_reader :model_name

    def parse(model_name)
      @model_name = model_name
      return ParsedProperties.new(klass, parent_class, model_name) if klass
      false
    end

    def klass
      @klass ||= eval_file(sandbox_model, file_path)
    end

    def sandbox_model
      source = RubyParse.new(read_file)
      if source.has_parent_class? && Config.model_base_classes.include?(source.parent_class_name)
        source.modify_parent_class('ActiveMocker::ActiveRecord::Base')
      else
        load_parent_class(source.parent_class_name)
        read_file
      end
    end

    def load_parent_class(class_name)
      @parent_class = class_name
      file_name     = class_name.tableize.singularize
      source        = RubyParse.new(read_file(file_name)).modify_parent_class('ActiveMocker::ActiveRecord::Base')
      eval_file(source, file_path(file_name))
    end

    def module_namespace
      @module ||= Module.new
    end

    def eval_file(string, file_path)
      failure = false
      begin
        module_namespace.module_eval(string, file_path)
        _klass = module_namespace.const_get(module_namespace.constants.last)
      rescue SyntaxError => e
        log_loading_error(e, true)
        failure = true
      rescue Exception => e
        log_loading_error(e, false)
        failure = true
      end
      return false if failure
      _klass
    end

    def log_loading_error(msg, print_to_stdout=false)
      main = "Error loading Model: #{model_name} \n\t#{msg}\n"
      file = "\t#{file_path}\n"
      stack_trace = msg.backtrace_locations.map{|e| "\t#{e}"}.join("\n")
      str = main + file + stack_trace
      Config.logger.error str
      print str if print_to_stdout
    end

    def parent_class
      @parent_class
    end

    def read_file(m_name=model_name)
      Config.file_reader.read(file_path(m_name))
    end

    def file_path(m_name=model_name)
      "#{Config.model_dir}/#{m_name}.rb"
    end

    class ParsedProperties

      attr_reader :klass, :parent_class, :model_name

      def initialize(klass, parent_class, model_name)
        @klass        = klass
        @parent_class = parent_class
        @model_name   = model_name
      end

      def rails_version
        @rails_version ||= model_name.classify.constantize
      end

      def belongs_to
        rails_version.reflect_on_all_associations(:belongs_to)
      end

      def has_one
        rails_version.reflect_on_all_associations(:has_one)
      end

      def has_and_belongs_to_many
        rails_version.reflect_on_all_associations(:has_and_belongs_to_many)
      end

      def has_many
        rails_version.reflect_on_all_associations(:has_many)
      end

      def table_name
        rails_version.table_name
      end

      def primary_key
        rails_version.primary_key
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
          {m => klass.method(m).parameters}
        end
      end

      def instance_methods_with_arguments
        instance_methods.map do |m|
          {m => klass.instance_method(m).parameters}
        end
      end

      def instance_methods
        methods = klass.public_instance_methods(false)
        methods << klass.superclass.public_instance_methods(false) if klass.superclass != ActiveRecord::Base
        methods.flatten
      end

      def constants
        const = {}
        klass.constants.each { |c| const[c] = klass.const_get(c) }
        const = const.reject do |c, v|
          v.class == Module || v.class == Class
        end
        const
      end

      def modules
        {included: process_module_names(klass._included),
         extended: process_module_names(klass._extended)}
      end

      def process_module_names(names)
        names.reject { |m| /#{klass.inspect}/ =~ m.name }.map(&:inspect)
      end

    end

  end

end