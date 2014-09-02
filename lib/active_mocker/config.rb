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
        unless @first_load
          load_defaults
          @first_load = true
        end
        yield self
        check_required_settings
      end

      def load_defaults
        @schema_file        = nil
        @model_dir          = nil
        @mock_dir           = nil
        @model_base_classes = %w[ ActiveRecord::Base ]
        @file_reader        = FileReader
        @logger             = default_logger
        rails_defaults if Object.const_defined?('Rails')
      end

      def check_required_settings
        instance_variables.each do |ivar|
          raise "ActiveMocker::Config ##{ivar.to_s.sub('@', '')} must be specified!" if instance_variable_get(ivar).nil?
        end
      end

      def default_logger
        dir = File.dirname('log/active_mocker.log')
        FileUtils.mkdir_p(dir) unless File.directory?(dir)
        @default_logger ||= ::Logger.new('log/active_mocker.log', 'daily')
      end

      def rails_defaults
        @schema_file        = File.join(Rails.root, 'db/schema.rb')
        @model_dir          = File.join(Rails.root, 'app/models')
        @mock_dir           = File.join(Rails.root, 'spec/mocks')
      end

    end

  end

end

