require 'ruby-progressbar'
require 'forwardable'
module ActiveMocker
class Generate
  extend Forwardable

  attr_reader :silence

  def initialize(silence: false)
    @silence = silence
    create_template
  end

  private

  def generate_model_schema
    ActiveMocker::ModelSchema::Assemble.new(progress: progress).run
  end

  def model_count
    @model_count ||= ActiveMocker::ModelSchema::Assemble.new.models.count
  end

  def progress
    return @progress if !@progress.nil? || silence == true
    progress_options = {:title => 'Generating Mocks',
                        :total => model_count * 2,
                        format: '%t |%b>>%i| %p%%'}
    @progress = ProgressBar.create(progress_options)
  end

  def increment_progress
    progress.increment unless silence
  end

  def create_template
    mocks_created = 0
    not_valid_models = 0
    FileUtils.rm_rf("#{Config.mock_dir}/", secure: true)
    FileUtils::mkdir_p Config.mock_dir unless File.directory? Config.mock_dir
    generate_model_schema.each do |model|
      if model.class == ModelLoadError::HasNoParentClass
        Config.logger.info "#{ModelLoadError::HasNoParentClass} #{model}. Model will not be mocked."
        not_valid_models += 1
        next
      end
      begin

      klass_str = model.render(File.open(File.join(File.expand_path('../', __FILE__), 'mock_template.erb')).read, mock_append_name)

      File.open(File.join(Config.mock_dir,"#{model.class_name.tableize.singularize}_mock.rb"), 'w').write(klass_str)
      Config.logger.info "saving mock #{model.class_name} to #{Config.mock_dir}"

      rescue Exception => exception
        Config.logger.debug $!.backtrace
        Config.logger.debug exception
        Config.logger.info "Failed to load #{model.class_name} model."
        next
      end
      mocks_created += 1
      increment_progress
    end
    progress.finish unless silence
    Config.logger.info "Generated #{mocks_created} of #{model_count} mocks."
    failed_mocks = (model_count - not_valid_models) - mocks_created
    if failed_mocks > 0
      puts "#{failed_mocks} mock(s) out of #{model_count} failed. See log for more info."
    end
  end

  def mock_append_name
    'Mock'
  end

end
end


