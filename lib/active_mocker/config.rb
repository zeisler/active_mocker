module ActiveMocker

  class Config
    class << self

      attr_accessor :schema_file,
                    :model_dir,
                    :mock_dir,
                    :logger,
                    :model_base_classes,
                    :file_reader

      def model_base_classes=(val)
        @model_base_classes = val
      end

      def set
        load_defaults
        yield self
      end

      def load_defaults
        @schema_file        = nil unless @schema_file
        @model_dir          = nil unless @model_dir
        @mock_dir           = nil unless @mock_dir
        @model_base_classes = %w[ ActiveRecord::Base ] unless @model_base_classes
        @file_reader        = FileReader     unless @file_reader
        @logger             = default_logger unless @logger
        rails_defaults if Object.const_defined?('Rails')
      end

      def reset_all
        [ :@schema_file,
          :@model_dir,
          :@mock_dir,
          :@model_base_classes,
          :@file_reader,
          :@logger,
          :@schema_file,
          :@model_dir,
          :@mock_dir].each{|ivar| instance_variable_set(ivar, nil)}
      end

      def default_logger
        dir = File.dirname('log/active_mocker.log')
        FileUtils.mkdir_p(dir) unless File.directory?(dir)
        @default_logger ||= ::Logger.new('log/active_mocker.log', 'daily')
      end

      def rails_defaults
        @schema_file = File.join(Rails.root, 'db/schema.rb') unless @schema_file
        @model_dir   = File.join(Rails.root, 'app/models')   unless @model_dir
        @mock_dir    = File.join(Rails.root, 'spec/mocks')   unless @mock_dir
      end

    end

  end

end

