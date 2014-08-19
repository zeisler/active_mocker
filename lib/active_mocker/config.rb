module ActiveMocker

  class Config
    class << self

      attr_accessor :schema_file,
                    :model_dir,
                    :mock_dir,
                    :logger,
                    :model_base_classes,
                    :file_reader

      def set
        @first_load ||= load_defaults
        yield self
        check_required_settings
      end

      def load_defaults
        @schema_file        = nil
        @model_dir          = nil
        @mock_dir           = nil
        @model_base_classes = %w[ ActiveRecord::Base ]
        @file_reader        = FileReader
        @logger = ::Logger.new(STDOUT)
      end

      def check_required_settings
        instance_variables.each do |ivar|
          raise "ActiveMocker::Config ##{ivar.to_s.sub('@', '')} must be specified!" if instance_variable_get(ivar).nil?
        end
      end

      def clear_settings
        load_defaults
      end

    end

  end

end

