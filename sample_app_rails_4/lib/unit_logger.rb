require 'logger'
class UnitLogger

  def self.method_missing(meth, *args, &block)
    return Rails.logger.send(meth, *args, &block) if defined? Rails
    return unit.send(meth, *args, &block)
  end

  def self.unit
    return @logger unless @logger.nil?
    @logger = Logger.new(STDOUT)
    @logger.formatter = proc do |severity, datetime, progname, msg|
      msg
    end
    @logger.level = Logger::DEBUG
    @logger
  end

end



