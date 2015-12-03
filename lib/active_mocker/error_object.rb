module ActiveMocker
  class ErrorObject
    attr_reader :message, :original_error, :level, :type, :class_name

    def initialize(level: :warn, message:, class_name:, original_error: nil, type:)
      @message        = message
      @class_name     = class_name
      @original_error = original_error
      @level          = level
      @type           = type
    end

    def self.build_from(object: nil, exception: nil, class_name: nil, type: nil)
      if object
        args              = [:message, :original_error, :level, :type, :class_name].each_with_object({}) do |meth, hash|
          hash[meth] = object.public_send(meth) if object.respond_to? meth
        end
        args[:type]       = type unless type.nil?
        args[:class_name] = class_name unless class_name.nil?
        return self.new(args)
      elsif exception && class_name
        return self.new(message:        exception.message,
                        class_name:     class_name,
                        original_error: exception,
                        type:           type ? type : :standard_error)
      end
      raise ArgumentError
    end

    def original_error?
      original_error.present?
    end

    private

    def self.levels
      [:info, :warn, :fatal]
    end
  end
end