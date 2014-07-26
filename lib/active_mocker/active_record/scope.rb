module ActiveMocker

  module ActiveRecord

    module Scope

      def scope(method_name, proc)
        get_named_scopes[method_name] = proc
      end

      def get_named_scopes
        @scope_methods ||= {}
      end

    end

  end

end



