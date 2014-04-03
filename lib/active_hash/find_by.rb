module ActiveHash

  module ARApi

    module FindBy

      def find_by(options = {})
        send("find_by_#{options.keys.first}", options.values.first)
      end

    end

  end

end