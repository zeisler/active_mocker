module ActiveMocker

  module ActiveRecord

    module UnknownModule

      def include(_module)
        try_and_log('include', _module, caller)
      end

      def extend(_module)
        try_and_log('extend', _module, caller)
      end

      private

      def try_and_log(method, name, _caller)
        begin
          super _module
        rescue => e
          Config.logger.debug "#{method} module #{name} from class #{self.name}.\n  #{_caller}\n  #{e}"
        end
      end

    end

  end


end