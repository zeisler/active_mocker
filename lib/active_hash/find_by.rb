module ActiveHash

  module ARApi

    module FindBy

      def find_by(options = {})
        send(:where, options).first
      end

    end

  end

end