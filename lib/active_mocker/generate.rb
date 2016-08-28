# frozen_string_literal: true
require_relative "file_writer"
module ActiveMocker
  class ActiveRecordModelsWithFiles

    def initialize(display_errors:)
      @display_errors = display_errors
    end

    include Enumerable

    def each(&block)
      to_a.each(&block)
    end

    def to_a
      @to_a ||= active_record_models_with_files
    end

    def current_mock_paths
      Dir.glob(File.join(config.mock_dir, "/**/*_#{config.mock_append_name.underscore}.rb"))
    end

    private

    attr_reader :display_errors

    class KlassFile
      attr_reader :const, :source_path, :destination_path

      def initialize(const:, source_path:, destination_path: nil)
        @const            = const
        @source_path      = source_path
        @destination_path = destination_path || mock_file_path
      end

      def mock_file_path
        File.join(Config.mock_dir, mock_file_name)
      end

      def mock_file_name
        "#{const.name.underscore}_#{ActiveMocker::Config.mock_append_name.underscore}.rb"
      end
    end

    def active_record_models_with_files
      models_paths.map do |file|
        model = constant_from(model_name_from(file))
        KlassFile.new(const: model, source_path: file) if model
      end.compact
    end

    def models_paths
      @models_paths ||= Dir.glob(config.single_model_path || File.join(config.model_dir, "**/*.rb"))
    end

    def constant_from(model_name)
      constant = model_name.constantize
      return unless constant.ancestors.include?(ActiveRecord::Base)
      constant
    rescue NameError, LoadError => e
      display_errors.wrap_an_exception(e, model_name)
      nil
    end

    def model_name_from(file)
      FilePathToRubyClass.new(
        base_path:  config.model_dir,
        class_path: file
      ).to_s
    end

    def config
      ActiveMocker::Config
    end
  end
end

module ActiveMocker
  class Generate
    def initialize(klasses: ActiveRecordModelsWithFiles)
      check_directory!(:mock_dir)
      check_directory!(:model_dir)
      raise_missing_arg(:model_dir) unless Dir.exist?(config.model_dir)
      @display_errors             = DisplayErrors.new
      @klasses                    = klasses.new(display_errors: @display_errors)
      @display_errors.klass_count = @klasses.count
    end

    # @return self
    def call
      clean_up
      progress_init

      klasses.each do |klass|
        write_file(klass)
        progress.increment
      end

      display_errors.display_errors
      self
    end

    def klass_constants
      @klass_constants ||= klasses.map(&:const)
    end

    private

    attr_reader :display_errors, :progress, :klasses

    def check_directory!(type)
      value = config.send(type)
      raise_missing_arg(type) if value.nil? || value.empty?
    end

    def raise_missing_arg(type)
      raise ArgumentError, "#{type} is missing a valued value!"
    end

    def write_file(klass)
      FileWriter.new(
        model:          klass.const,
        const:          klass.const,
        mock_file_path: klass.destination_path,
        file:           klass.source_path,
        display_errors: display_errors,
        config:         config,
        klass_names:    klass_names
      ).write!
    end

    def progress_init
      @progress = config.progress_class.create(klass_constants.count)
    end

    def klass_names
      @klass_names ||= klass_constants.map(&:name)
    end

    def config
      ActiveMocker::Config
    end

    def clean_up
      delete_mocks unless config.single_model_path
    end

    def delete_mocks
      FileUtils.rm klasses.current_mock_paths
    end
  end
end
