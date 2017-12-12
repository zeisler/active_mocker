# frozen_string_literal: true
require "colorize"
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

    def any_errors?
      uniq_errors.count > 0
    end

    def display_errors
      uniq_errors.each do |e|
        next unless ENV["DEBUG"] || !(e.level == :debug)

        display_verbosity_three(e) || display_verbosity_two(e)
      end

      display_verbosity_one
    end

    def error_summary
      display "errors: #{error_count}, warn: #{warn}, info: #{info}"
      display "Failed models: #{failed_models.join(", ")}" if failed_models.count > 0
    end

    def number_models_mocked
      if success_count < model_count || any_errors?
        display "Mocked #{success_count} ActiveRecord #{plural("Model", success_count)} out of #{model_count} #{plural("file", model_count)}."
      end
    end

    private

    def plural(string, count, plural="s")
      count > 1 || count.zero? ? "#{string}#{plural}" : string
    end

    def display(msg)
      out.puts(msg)
    end

    def display_verbosity_three(error)
      return unless ActiveMocker::Config.error_verbosity == 3

      display_error_header(error)
      display error.level

      display_original_error(error)
    end

    def display_original_error(e)
      original = e.original_error
      return unless original

      display original.message.colorize(e.level_color)
      display original.backtrace
      display original.class.name.colorize(e.level_color)
    end

    def display_verbosity_two(e)
      return unless ActiveMocker::Config.error_verbosity == 2

      display_error_header(e)
    end

    def display_error_header(e)
      display "#{e.class_name} has the following errors:"
      display e.message.colorize(e.level_color)
    end

    def display_verbosity_one
      return unless ActiveMocker::Config.error_verbosity > 0

      error_summary if any_errors?

      number_models_mocked

      return unless any_errors?
      display "To see more/less detail set ERROR_VERBOSITY = 0, 1, 2, 3"
    end

    def error_count
      errors_for(:red)
    end

    def warn
      errors_for(:yellow)
    end

    def info
      errors_for(:default)
    end

    def errors_for(level)
      uniq_errors.count { |e| [level].include? e.level_color }
    end
  end
end
