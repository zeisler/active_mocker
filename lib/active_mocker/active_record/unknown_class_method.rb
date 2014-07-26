module ActiveMocker

  module ActiveRecord

    module UnknownClassMethod

      def method_missing(meth, *args)
        Logger.debug "ActiveMocker :: DEBUG :: #{meth} called from class #{self.name} is unknown and will not be available in mock.\n"
      end

    end

  end

end

