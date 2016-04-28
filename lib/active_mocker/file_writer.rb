module ActiveMocker
  class FileWriter
    include Virtus.model
    delegate :name, to: :model, prefix: true

    attribute :model, Object
    attribute :file, String
    attribute :display_errors
    attribute :config
    attribute :model_names, Array

    def write!
      assure_dir_path_exists!

      safe_write { |f| process!(f)}
    end

    private

    def process!(file_out)
      result = create_mock(file_out)
      status = collect_errors(result.errors)

      ok = result.completed? && status.successful?
      return unless ok

      display_errors.success_count += 1
    end

    def safe_write
      File.open(mock_file_path, "w") do |file_out|
        begin
          yield file_out
        rescue StandardError => e
          rescue_clean_up(e, file_out)
        end
      end
    end

    def rescue_clean_up(e, file_out)
      display_errors.failed_models << model_name
      file_out.close unless file_out.closed?
      File.delete(file_out.path) if File.exist?(file_out.path)
      display_errors.wrap_an_exception(e, model_name)
    end

    def schema_scrapper
      @schema_scrapper ||= ActiveRecordSchemaScrapper.new(model: model)
    end

    def mock_file_path
      File.join(Config.mock_dir, mock_file_name)
    end

    def mock_file_name
      "#{model_name.underscore}_#{config.mock_append_name.underscore}.rb"
    end

    def assure_dir_path_exists!
      unless File.exist?(File.dirname(mock_file_path))
        FileUtils.mkdir_p(File.dirname(mock_file_path))
      end
    end

    def create_mock(file_out)
      MockCreator.new(file:                 File.open(file),
                      file_out:             file_out,
                      schema_scrapper:      schema_scrapper,
                      klasses_to_be_mocked: model_names,
                      enabled_partials:     enabled_partials,
                      mock_append_name:     config.mock_append_name).create
    end

    OtherErrors = Struct.new(:successful?)

    def collect_errors(create_mock_errors)
      display_errors.wrap_errors(schema_scrapper.associations.errors, model_name, type: :associations)
      display_errors.wrap_errors(schema_scrapper.attributes.errors,   model_name, type: :attributes)

      if create_mock_errors.present? || schema_scrapper.attributes.errors.any? { |e| e.level == :error }
        display_errors.failed_models << model_name
        File.delete(mock_file_path) if File.exist?(mock_file_path)
        display_errors.add(create_mock_errors)
        OtherErrors.new(false)
      else
        OtherErrors.new(true)
      end
    end

    def enabled_partials
      if config.disable_modules_and_constants
        MockCreator.enabled_partials_default - [*:modules_constants]
      else
        MockCreator.enabled_partials_default
      end
    end
  end

end
