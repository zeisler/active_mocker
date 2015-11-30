module ActiveMocker
  class Generate

    def initialize
      raise ArgumentError, "mock_dir is missing a valued value!" if config.mock_dir.nil? || config.mock_dir.empty?
      create_mock_dir
      raise ArgumentError, "model_dir is missing a valued value!" if config.model_dir.nil? || config.model_dir.empty? || !Dir.exists?(config.model_dir)
      @success_count = 0
      @errors = []
    end

    # @returns self
    def call
      progress_init
      models_paths.each do |file|
        model_name     = model_name(file)
        model          = model_name.constantize
        mock_file_name = "#{model_name.underscore}_#{mock_append_name.underscore}.rb"
        mock_file_path = File.join(Config.mock_dir, mock_file_name)
        schema_scrapper = schema_scrapper(model)
        File.open(mock_file_path, 'w') do |file_out|
          begin
            r = create_mock(file, file_out, schema_scrapper)
            collect_errors(mock_file_path, r, schema_scrapper)
            @success_count += 1 if r.completed?
          rescue => e
            rescue_clean_up(e, file_out, model_name)
          end
        end
        progress.increment
      end
      display_errors
      failure_count_message
      self
    end

    private

    attr_reader :success_count, :errors

    def create_mock(file, file_out, schema_scrapper)
      MockCreator.new(file:                 File.open(file),
                      file_out:             file_out,
                      schema_scrapper:      schema_scrapper,
                      klasses_to_be_mocked: model_names,
                      enabled_partials:     enabled_partials).create
    end

    def collect_errors(mock_file_path, r, schema_scrapper)
      unless r.errors.empty?
        File.delete(mock_file_path)
        errors.concat(r.errors)
      end
      unless schema_scrapper.associations.errors.empty?
        errors.concat(schema_scrapper.associations.errors.uniq(&:message))
      end
      unless schema_scrapper.attributes.errors.empty?
        errors.concat(schema_scrapper.attributes.errors.uniq(&:message))
      end
    end

    def rescue_clean_up(e, file_out, model_name)
      file_out.close
      File.delete(file_out.path)
      e = OpenStruct.new(message: e.message, class_name: model_name, original_error: e) if e.class <= Exception
      errors << e
    end

    def schema_scrapper(model)
      # if model.respond_to?(:abstract_class?) && model.abstract_class?
      #   null_collection = OpenStruct.new(to_a: [], errors: [])
      #   OpenStruct.new(associations: null_collection, attributes: null_collection, abstract_class?: true)
      # else
        ActiveRecordSchemaScrapper.new(model: model)
      # end
    end

    def display_errors
      errors.flatten.each do |e|
        if config.error_verbosity == 2
          puts "#{e.class_name} has failed:"
          puts e.message
          puts e.original_error.message if e.respond_to? :original_error
          puts e.original_error.backtrace if e.respond_to? :original_error
          puts e.original_error.class.name if e.respond_to? :original_error
          raise e.original_error if e.respond_to? :original_error
        elsif config.error_verbosity == 1
          puts e.message
        end
      end
    end

    def failure_count_message
      if config.error_verbosity > 0 && success_count < models_paths.count
        "#{ models_paths.count - success_count } mock(s) out of #{models_paths.count} failed."\
        "To see more detail set error_verbosity = 2 or to mute this error set error_verbosity = 0."
      end
    end

    def model_name(file)
      File.basename(file, '.rb').camelize
    end

    def model_names
      @model_names ||= models_paths.map { |p| model_name(p) }
    end

    def progress
      @progress
    end

    def progress_init
      @progress = config.progress_class.new(models_paths.count)
    end

    def models_paths
      @models_paths ||= Dir.glob(config.single_model_path || File.join(config.model_dir, "*.rb"))
    end

    def config
      ActiveMocker::Config
    end

    def create_mock_dir
      FileUtils::mkdir_p(config.mock_dir) unless Dir.exists?(config.mock_dir)
    end

    def mock_append_name
      'Mock'
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