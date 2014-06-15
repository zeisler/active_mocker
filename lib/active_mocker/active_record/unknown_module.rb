module ActiveMocker

  module UnknownModule

    def include(_module)
      try_and_log('include', _module)
    end

    def extend(_module)
      try_and_log('extend', _module)
    end

    private

    def try_and_log(type, name)
      begin
        super _module
      rescue => e
        Logger.debug "ActiveMocker :: Debug :: Can't #{type} module #{name} from class #{self.name}.\n\t\t\t\t\t\t\t\t#{caller}\n"
        Logger.debug "\t\t\t\t\t\t\t\t#{e}"
      end
    end

  end

end