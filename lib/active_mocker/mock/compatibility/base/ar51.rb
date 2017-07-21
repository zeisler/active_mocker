# frozen_string_literal: tru

module ActiveMocker
  class Base
    module AR51
      def delete_all
        super
      end
    end
  end
end
