# frozen_string_literal: true
require "logger"
class UnitLogger
  def self.method_missing(meth, *args, &block)
    return Rails.logger.send(meth, *args, &block) if defined? Rails
    unit.send(meth, *args, &block)
  end

  def self.unit
    return @logger unless @logger.nil?
    @logger = Logger.new(STDOUT)
    @logger.formatter = proc do |_severity, _datetime, _progname, msg|
      msg
    end
    @logger.level = Logger::DEBUG
    @logger
  end
end
