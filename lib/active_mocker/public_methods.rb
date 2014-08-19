module ActiveMocker

  class << self

    # Method will be deprecated in v2
    def self.mock(model_name, options=nil)
      require File.join(Config.mock_dir,
                        "#{model_name.tableize.singularize}_mock.rb")
      "#{model_name}Mock".constantize
    end

    # Override default Configurations
    #
    #  ActiveMocker.configure do |config|
    #    config.schema_file = File.join(Rails.root, 'db/schema.rb')
    #    config.model_dir   = File.join(Rails.root, 'app/models')
    #    config.mock_dir    = File.join(Rails.root, 'spec/mocks')
    #
    #    # If a model has a base class that still behaves like ActiveRecord but doesn't directly inherit from it add it
    #    # to the model_base_classes array
    #    config.model_base_classes = %w[ ActiveRecord::Base ]
    #
    #    config.logger      = Rails.logger
    #  end
    #
    def configure(&block)
      Config.set(&block)
    end

    alias_method :config, :configure

    # Generates Mocks file
    def create_mocks
      Generate.new
    end

  end

end