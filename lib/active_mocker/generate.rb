require 'ruby-progressbar'
require 'forwardable'
module ActiveMocker
class Generate
  extend Config
  extend Forwardable

  @@_self = self
  def_delegators :@@_self,
                 :schema_attributes,
                 :model_attributes,
                 :model_dir,
                 :schema_file,
                 :model_file_reader,
                 :schema_file_reader,
                 :mock_dir,
                 :logger

  attr_reader :silence

  def initialize(silence: false)
    @silence = silence
    create_template
  end

  def self.configure(&block)
    config(&block)
  end

  def self.mock(model_name, force_reload: false)
    load_mock(model_name)
  end

  def self.load_mock(model_name)
    load File.join(mock_dir, "#{model_name.tableize.singularize}_mock.rb")
    "#{model_name}Mock".constantize
  end

  def generate_model_schema
    ActiveMocker::ModelSchema::Generate.new(schema_file: schema_file, models_dir: model_dir, logger: logger, progress: progress).run
  end

  def model_count
    ActiveMocker::ModelSchema::Generate.new(schema_file: schema_file, models_dir: model_dir, logger: logger).models.count
  end

  def progress
    return @progress if !@progress.nil? || silence == true
    progress_options = {:title => "Generating Mocks",
                        :total => model_count * 2,
                        format: '%t |%b>>%i| %p%%'}
    @progress = ProgressBar.create(progress_options)
  end

  def increment_progress
    progress.increment unless silence
  end

  def create_template
    mocks_created = 0
    generate_model_schema.each do |model|
      begin

      klass_str = model.render(File.open(File.join(File.expand_path('../', __FILE__), 'mock_template.erb')).read, mock_append_name)
      FileUtils::mkdir_p mock_dir unless File.directory? mock_dir
      File.open(File.join(mock_dir,"#{model.table_name.singularize}_mock.rb"), 'w').write(klass_str)
      logger.info "saving mock #{model.class_name} to #{mock_dir}"

      rescue Exception => exception
        logger.debug $!.backtrace
        logger.debug exception
        logger.info "failed to load #{model} model"
        next
      end
      mocks_created += 1
      increment_progress
    end
    progress.finish unless silence
    logger.info "Generated #{mocks_created} of #{model_count} mocks"
  end

  def mock_append_name
    'Mock'
  end

end
end


