module ActiveMocker

  class << self

    # Method will be deprecated in v2
    def mock(model_name, options=nil)
      Generate.mock(model_name)
    end

    # Override default Configurations
    #
    #  ActiveMocker::Generate.configure do |config|
    #    config.schema_file = File.join(Rails.root, 'db/schema.rb')
    #    config.model_dir   = File.join(Rails.root, 'app/models')
    #    config.mock_dir    = File.join(Rails.root, 'spec/mocks')
    #    config.logger      = Rails.logger
    #  end
    #
    def configure(&block)
      Generate.configure(&block)
    end

    alias_method :config, :configure

    # Generates Mocks file
    def create_mocks
      Generate.new
    end

  end

end