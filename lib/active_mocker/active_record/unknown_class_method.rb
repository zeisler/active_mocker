module ActiveMocker

  module ActiveRecord

    module UnknownClassMethod

      def method_missing(meth, *args)
        Config.logger.debug "ActiveMocker :: DEBUG :: #{meth} called from class #{self.name.demodulize}" +
                         " is unknown and will not be available in mock.\n  #{caller.first}\n"
      end

    end

  end

end

