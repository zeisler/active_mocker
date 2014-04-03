module ActiveHash

  module ARApi

    module Update

      def update(options={})
        options.each do |method, value|
          send("#{method}=", value)
        end

      end

    end

  end

end