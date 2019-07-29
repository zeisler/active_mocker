# frozen_string_literal: true

require_relative "file_writer"

module ActiveMocker
  class Generate
    def initialize
      check_directory!(:mock_dir)
      create_mock_dir
      check_directory!(:model_dir)
      raise_missing_arg(:model_dir) unless Dir.exist?(config.model_dir)

      @display_errors = DisplayErrors.new(models_paths.count)
    end

    # @return self
    def call
      clean_up
      progress_init

      active_record_models_with_files.each do |model, file|
        write_file(model, file)

        progress.increment
      end

      display_errors.display_errors
      self
    end

    def active_record_models
      @active_record_models ||= active_record_models_with_files.map(&:first)
    end

    private

    attr_reader :display_errors, :progress

    def check_directory!(type)
      value = config.send(type)

      raise_missing_arg(type) if value.blank?
    end

    def raise_missing_arg(type)
      raise ArgumentError, "#{type} is missing a valued value!"
    end

    def write_file(model, file)
      writer = FileWriter.new(
        model: model,
        file: file,
        display_errors: display_errors,
        config: config,
        model_names: model_names,
      )

      writer.write!
    end

    def progress_init
      @progress = config.progress_class.create(active_record_models.count)
    end

    def model_names
      @model_names ||= active_record_models.map(&:name)
    end

    def active_record_models_with_files
      @active_record_models_with_files ||= models_paths.map do |file|
        model = constant_from(model_name_from(file))
        [model, file] if model
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
        base_path: config.model_dir,
        class_path: file,
      ).to_s
    end

    def config
      ActiveMocker::Config
    end

    def create_mock_dir
      FileUtils.mkdir_p(config.mock_dir) unless Dir.exist?(config.mock_dir)
    end

    def clean_up
      delete_mocks unless config.single_model_path
    end

    def delete_mocks
      FileUtils.rm Dir.glob(File.join(config.mock_dir, "/**/*_#{config.mock_append_name.underscore}.rb"))
    end
  end
end
