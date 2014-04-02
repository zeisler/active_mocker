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
                  :model_file_reader

    def config
      default
      yield self
    end

    def default
      schema_file         = nil
      model_dir           = nil
      active_hash_as_base = false
      schema_attributes   = true
      model_relationships = true
      model_methods       = true
      mass_assignment     = true
      log_level           = Logger::WARN
    end

    def log_level=(level)
      Logger_.level = level
    end

  end

end

