module ActiveMocker

  module UnknownClassMethod

    def method_missing(meth, *args)
      Logger.debug "ActiveMocker :: #{meth} called from class #{self.name} is unknown and will not be available in mock."
    end

  end

end

