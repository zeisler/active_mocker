class Reparameterize

  def self.call(params, list=false)
    return params.map{|state, param| param }.join(", ") if list

    params.map do |state, param|
      case state
        when :req
          param
        when :rest
          "*#{param}"
        when :opt
          "#{param}=nil"
        else
          param
      end
    end.join(", ")

  end

end