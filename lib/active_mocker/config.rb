module ActiveMocker

  module Config
    extend self

    attr_accessor :schema_file,
                  :model_dir,
                  :schema_attributes,
                  :model_attributes,
                  :schema_file_reader,
                  :model_file_reader,
                  :clear_cache,
                  :migration_dir

    def config
      @@first_load ||= reload_default
      yield self
      check_required_settings
      require_active_hash
    end

    def reload_default
      @log_level           = Logger::WARN
      @schema_file         = nil
      @model_dir           = nil
      @schema_attributes   = true
      @model_attributes    = true
      @clear_cache         = false
      @schema_file_reader  = nil
      @model_file_reader   = nil
      @migration_dir       = nil
    end

    def check_required_settings
      raise 'schema_file must be specified' if schema_file.nil?
      raise 'model_dir must be specified'   if model_dir.nil?
      raise 'migration_dir must be specified'   if migration_dir.nil?
    end

    def require_active_hash
      require 'active_hash'  if schema_attributes
    end

    def log_level=(level)
      Logger_.level = level
    end

    def active_hash_as_base=(arg)
      Logger_.warn('Deprecation Warning: config option `active_hash_as_base` is now model_attributes')
    end

    def model_relationships=(arg)
      Logger_.warn('Deprecation Warning: config option `model_relationships` is now model_attributes')
    end

    def model_methods=(arg)
      Logger_.warn('Deprecation Warning: config option `model_methods` is now model_attributes')
    end

    def mass_assignment=(arg)
      Logger_.warn('Deprecation Warning: config option `mass_assignment` is now model_attributes')
    end

  end

end

