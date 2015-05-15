module ActiveMocker
# @api private
  class Reparameterize

    def self.call(params, method_parameters: nil)
      return method_parameters(params) unless method_parameters.nil?
      method_arguments(params)
    end

    # Method arguments are the real values passed to (and received by) the function.
    def self.method_arguments(params)
      params.map do |state, param|
        case state
          when :req
            param
          when :rest
            "*#{param}"
          when :opt
            "#{param}=nil"
          when :keyreq
            "#{param}:"
          when :key
            "#{param}: nil"
        end
      end.join(', ')
    end

    # Method parameters are the names listed in the function definition.
    def self.method_parameters(params)
      params.map do |state, param|
        case state
          when :key, :keyreq
            "#{param}: #{param}"
          else
            param
        end
      end.join(', ')
    end

  end
end