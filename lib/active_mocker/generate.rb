require 'ruby-progressbar'
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

  def initialize
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
    ActiveMocker::ModelSchema::Generate.new(schema_file: schema_file, models_dir: model_dir, logger: logger).run
  end

  def create_template
    mocks_created = 0
    ProgressBar.create
    models = generate_model_schema
    progress_bar = ProgressBar.create(:title => "Generating Mocks", :starting_at => 0, :total => models.count, format: '%a %B %p%% %t')
    models.each do |model|
      # begin
        klass_str = ''
        klass_str = model.render(File.open(File.join(File.expand_path('../', __FILE__), 'mock_template.erb')).read, mock_append_name)
      FileUtils::mkdir_p mock_dir unless File.directory? mock_dir
      File.open(File.join(mock_dir,"#{model.table_name.singularize}_mock.rb"), 'w').write(klass_str)
      logger.info "saving mock #{model.class_name} to #{mock_dir}"

      # rescue Exception => exception
      #   logger.debug $!.backtrace
      #   logger.debug exception
      #   logger.info "failed to load #{model} model"
      #   next
      # end
      mocks_created += 1
      progress_bar.increment
    end
    logger.info "Generated #{mocks_created} of #{models.count} mocks"
  end

  def mock_append_name
    'Mock'
  end

end
end


