# frozen_string_literal: true
require "logger"
class UnitLogger
  def self.method_missing(meth, *args, &block)
    return unit.send(meth, *args, &block) unless unit.nil?
    return Rails.logger.send(meth, *args, &block) if defined? Rails
  end

  def self.unit
    return @logger unless @logger.nil?
    FileUtils.mkdir_p "log" unless File.directory? "log"
    File.open("log/test.log", "w").close unless File.exist? "log/test.log"
    @logger = ::Logger.new("log/test.log")
    @logger.formatter = proc do |_severity, _datetime, _progname, msg|
      msg
    end
    @logger.level = ::Logger::DEBUG
    @logger
  end
end
