# frozen_string_literal: true
module ActiveMocker
  class ErrorObject
    attr_reader :message, :level, :original_error, :type, :class_name

    def initialize(level: :warn, message:, class_name:, type:, original_error: nil)
      @level          = level
      @message        = message
      @class_name     = class_name
      @type           = type
      @original_error = original_error
    end

    def self.build_from(object: nil, exception: nil, class_name: nil, type: nil)
      if object
        args = [:message, :original_error, :level, :type, :class_name].each_with_object({}) do |meth, hash|
          hash[meth] = object.public_send(meth) if object.respond_to? meth
        end
        args[:type]       = type unless type.nil?
        args[:class_name] = class_name unless class_name.nil?
        return new(args)
      elsif exception && class_name
        return new(message:        exception.message,
                   class_name:     class_name,
                   original_error: exception,
                   type:           type ? type : :standard_error)
      end
      raise ArgumentError
    end

    def original_error?
      !original_error.nil?
    end

    def level_color
      case level
      when :standard_error, :fatal, :error
        :red
      when :warn
        :yellow
      when :info
        :default
      end
    end
  end
end
