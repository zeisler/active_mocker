module ActiveHash

  module ARApi
    require 'active_record/errors'

    module FindBy

      def find_by(options = {})
        send(:where, options).first
      end

      def find_by!(options={})
        result = find_by(options)
        raise ActiveRecord::RecordNotFound if result.blank?
        result
      end

    end

  end

end