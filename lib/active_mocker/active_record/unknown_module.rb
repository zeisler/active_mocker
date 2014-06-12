module ActiveMocker

  module UnknownModule

    def include(_module)
      begin
        super _module
      rescue => e

        Logger.debug "ActiveMocker :: Debug :: Can't include module #{_module} from class #{self.name}.\n\t\t\t\t\t\t\t\t#{caller}\n"
        Logger.debug "\t\t\t\t\t\t\t\t#{e}"

      end
    end

    def extend(_module)
      begin
        super _module
      rescue => e
        Logger.debug "ActiveMocker :: Debug :: Can't extend module #{_module} from class #{self.name}.\n\t\t\t\t\t\t\t\t#{caller}\n"
        Logger.debug "\t\t\t\t\t\t\t\t#{e}"
      end
    end

  end

end