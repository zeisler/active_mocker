# frozen_string_literal: true
module ActiveMocker
  class DisplayErrors
    attr_reader :errors, :model_count, :out
    attr_accessor :success_count, :failed_models

    def initialize(model_count, out: STDERR)
      @errors        = []
      @success_count = 0
      @model_count   = model_count
      @failed_models = []
      @out           = out
    end

    def add(errors)
      @errors.concat([*errors])
    end

    def wrap_errors(errors, model_name, type: nil)
      add errors.map { |e| ErrorObject.build_from(object: e, class_name: model_name, type: type ? type : e.try(:type)) }
    end

    def wrap_an_exception(e, model_name)
      add ErrorObject.build_from(exception: e, class_name: model_name)
    end

    def uniq_errors
      @uniq_errors ||= errors.flatten.compact.uniq.sort_by(&:class_name)
    end

    def display_errors
      uniq_errors.each do |e|
        next unless ENV["DEBUG"] || !(e.level == :debug)
        if ActiveMocker::Config.error_verbosity == 3
          out.puts "#{e.class_name} has the following errors:"
          out.puts e.message.colorize(e.level_color)
          out.puts e.level
          out.puts e.original_error.message.colorize(e.level_color) if e.original_error?
          out.puts e.original_error.backtrace if e.original_error?
          out.puts e.original_error.class.name.colorize(e.level_color) if e.original_error?
        elsif ActiveMocker::Config.error_verbosity == 2
          out.puts "#{e.class_name} has the following errors:"
          out.puts e.message.colorize(e.level_color)
        end
      end
      if ActiveMocker::Config.error_verbosity > 0 && uniq_errors.count > 0
        out.puts "Error Summary"
        error_summary
      end
      failure_count_message
      if ActiveMocker::Config.error_verbosity > 0 && uniq_errors.count > 0
        out.puts "To see more/less detail set error_verbosity = 0, 1, 2, 3"
      end
    end

    def error_summary
      error_count = uniq_errors.count { |e| [:red].include?(e.level_color) }
      warn        = uniq_errors.count { |e| [:yellow].include?(e.level_color) }
      info        = uniq_errors.count { |e| [:default].include?(e.level_color) }
      out.puts "errors: #{error_count}, warn: #{warn}, info: #{info}"
      out.puts "Failed models: #{failed_models.join(", ")}" if failed_models.count > 0
    end

    def failure_count_message
      if ActiveMocker::Config.error_verbosity > 0 && (success_count < model_count || uniq_errors.count > 0)
        out.puts "#{model_count - success_count} mock(s) out of #{model_count} failed."
      end
    end
  end
end
