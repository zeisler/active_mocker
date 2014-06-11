module ActiveMocker
  class Logger

    def self.set(logger)
      @@logger = logger
    end

    def self.method_missing(meth, *args, &block)
      @@logger ||= nil
      return nil if @@logger.nil?
      return @@logger.send(meth, *args, &block)
    end
  end
end