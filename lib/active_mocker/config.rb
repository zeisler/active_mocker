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
                  :migration_dir,
                  :mock_dir,
                  :logger,
                  :log_level

    def config
      @@first_load ||= reload_default
      yield self
      check_required_settings
    end

    def reload_default
      @schema_file         = nil
      @model_dir           = nil
      @schema_attributes   = true
      @model_attributes    = true
      @clear_cache         = false
      @schema_file_reader  = nil
      @model_file_reader   = nil
      @migration_dir       = nil
      @mock_dir            = nil
      @logger              = ::Logger.new(STDOUT)
    end

    def check_required_settings
      raise 'schema_file must be specified' if schema_file.nil?
      raise 'model_dir must be specified'   if model_dir.nil?
      raise 'mock_dir must be specified'    if mock_dir.nil?
    end

    def logger=(logger)
      @logger = logger
      Logger.set(logger)
    end

  end

end

