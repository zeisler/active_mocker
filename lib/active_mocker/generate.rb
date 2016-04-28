# frozen_string_literal: true
module ActiveMocker
  class Generate
    def initialize
      raise ArgumentError, "mock_dir is missing a valued value!" if config.mock_dir.nil? || config.mock_dir.empty?
      create_mock_dir
      raise ArgumentError, "model_dir is missing a valued value!" if config.model_dir.nil? || config.model_dir.empty? || !Dir.exist?(config.model_dir)
      @display_errors = DisplayErrors.new(models_paths.count)
    end

    # @return self
    def call
      clean_up
      progress_init

      active_record_models_with_files.each do |model, file|
        model_name      = model.name

        mock_file_name  = "#{model_name.underscore}_#{config.mock_append_name.underscore}.rb"
        mock_file_path  = File.join(Config.mock_dir, mock_file_name)
        assure_dir_path_exists(mock_file_path)
        schema_scrapper = ActiveRecordSchemaScrapper.new(model: model)
        File.open(mock_file_path, "w") do |file_out|
          begin
            result                       = create_mock(file, file_out, schema_scrapper)
            status                       = collect_errors(mock_file_path, result.errors, schema_scrapper, model_name)
            display_errors.success_count += 1 if result.completed? && status.successful?
          rescue => e
            rescue_clean_up(e, file_out, model_name)
          end
        end

        progress.increment
      end

      display_errors.display_errors
      self
    end

    def get_model_const(model_name)
      constant = model_name.constantize
      return unless constant.ancestors.include?(ActiveRecord::Base)
      constant
    rescue StandardError, LoadError => e
      display_errors.wrap_an_exception(e, model_name)
      nil
    end

    def active_record_models
      @active_record_models ||= active_record_models_with_files.map(&:first)
    end

    private

    attr_reader :display_errors, :progress

    def create_mock(file, file_out, schema_scrapper)
      MockCreator.new(file:                 File.open(file),
                      file_out:             file_out,
                      schema_scrapper:      schema_scrapper,
                      klasses_to_be_mocked: model_names,
                      enabled_partials:     enabled_partials,
                      mock_append_name:     config.mock_append_name).create
    end

    OtherErrors = Struct.new(:successful?)

    def collect_errors(mock_file_path, create_mock_errors, schema_scrapper, model_name)
      display_errors.wrap_errors(schema_scrapper.associations.errors, model_name, type: :associations)
      display_errors.wrap_errors(schema_scrapper.attributes.errors, model_name, type: :attributes)

      if create_mock_errors.present? || schema_scrapper.attributes.errors.any? { |e| e.level == :error }
        display_errors.failed_models << model_name
        File.delete(mock_file_path) if File.exist?(mock_file_path)
        display_errors.add(create_mock_errors)
        OtherErrors.new(false)
      else
        OtherErrors.new(true)
      end
    end

    def rescue_clean_up(e, file_out, model_name)
      display_errors.failed_models << model_name
      file_out.close unless file_out.closed?
      File.delete(file_out.path) if File.exist?(file_out.path)
      display_errors.wrap_an_exception(e, model_name)
    end

    def progress_init
      @progress = config.progress_class.create(active_record_models.count)
    end

    def model_names
      @model_names ||= active_record_models.map(&:name)
    end

    def active_record_models_with_files
      @active_record_models_with_files ||= models_paths.map do |file|
        model = get_model_const(model_name_for(file))
        [model, file] if model
      end.compact
    end

    def models_paths
      @models_paths ||= Dir.glob(config.single_model_path || File.join(config.model_dir, "**/*.rb"))
    end

    def model_name_for(file)
      FilePathToRubyClass.new(base_path: config.model_dir, class_path: file).to_s
    end

    def assure_dir_path_exists(file)
      unless File.exist?(File.dirname(file))
        FileUtils.mkdir_p(File.dirname(file))
      end
    end

    def config
      ActiveMocker::Config
    end

    def create_mock_dir
      FileUtils.mkdir_p(config.mock_dir) unless Dir.exist?(config.mock_dir)
    end

    def enabled_partials
      if config.disable_modules_and_constants
        MockCreator.enabled_partials_default - [*:modules_constants]
      else
        MockCreator.enabled_partials_default
      end
    end

    def clean_up
      delete_mocks unless config.single_model_path
    end

    def delete_mocks
      FileUtils.rm Dir.glob(File.join(config.mock_dir, "/**/*_#{config.mock_append_name.underscore}.rb"))
    end
  end
end
