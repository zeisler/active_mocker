module ActiveMocker
# @api private
class Reparameterize

  def self.call(params, param_list:nil)
    return param_list(params) unless param_list.nil?
    method_arguments(params)
  end

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

  def self.param_list(params)
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