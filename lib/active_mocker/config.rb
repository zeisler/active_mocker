module ActiveMocker

  module Config
    extend self

    attr_accessor :schema_file,
                  :model_dir,
                  :active_hash_as_base,
                  :schema_attributes,
                  :model_relationships,
                  :model_methods,
                  :mass_assignment,
                  :schema_file_reader,
                  :model_file_reader,
                  :active_hash_ext


    def config
      @@first_load ||= reload_default
      yield self
      check_required_settings
    end

    def reload_default
      @schema_file         = nil
      @model_dir           = nil
      @active_hash_as_base = false
      @schema_attributes   = true
      @model_relationships = true
      @model_methods       = true
      @mass_assignment     = true
      @active_hash_ext     = false
      @log_level           = Logger::WARN
    end

    def check_required_settings
      raise 'schema_file must be specified'if schema_file.nil?
      raise 'model_dir must be specified'if model_dir.nil?
    end

    def log_level=(level)
      Logger_.level = level
    end

  end

end

