require 'logger'
class UnitLogger

  def self.method_missing(meth, *args, &block)
    return Rails.logger.send(meth, *args, &block) if defined? Rails
    return unit.send(meth, *args, &block)
  end

  def self.unit
    return @logger unless @logger.nil?
    FileUtils::mkdir_p 'log' unless File.directory? 'log'
    File.open('log/test.log', 'w').close unless File.exist? 'log/test.log'
    @logger = ::Logger.new('log/test.log')
    @logger.formatter = proc do |severity, datetime, progname, msg|
      msg
    end
    @logger.level = ::Logger::DEBUG
    @logger
  end

end



