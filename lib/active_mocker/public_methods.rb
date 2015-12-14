module ActiveMocker
  class << self
    # Override default Configurations
    #
    #  ActiveMocker.configure do |c|
    #    c.model_dir=          # Directory of ActiveRecord models
    #    c.mock_dir=           # Directory to save mocks
    #    c.single_model_path=  # Path to generate a single mock
    #    c.progress_bar=       # False disables progress bar from sending to STDOUT
    #                            or pass a class that takes a count in the initializer and responds to #increment.
    #    c.error_verbosity=    # 0 = none
    #                          # 1 = Summary of failures
    #                          # 2 = One line per error
    #                          # 3 = Errors with exception backtrace
    #    c.disable_modules_and_constants= # Modules are include/extend along with constant declarations.
    #                                     # Default is false, to disable set to true.
    #  end
    #
    # @returns self
    # @yield [Config]
    def configure(&block)
      Config.set(&block)
      self
    end
    alias_method :config, :configure

    # Generates Mocks file
    # @returns self
    def create_mocks
      Generate.new.call
      self
    end
  end
end