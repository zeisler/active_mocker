module ActiveMocker
  class Logger

    def self.set(logger)
      @@logger = logger
    end

    def self.method_missing(meth, *args, &block)
      return @@logger.send(meth, *args, &block)
    end
  end
end