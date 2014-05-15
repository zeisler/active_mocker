require 'pathname'
module ActiveMocker
  class SchemaReader

    attr_reader :model_name,
                :schema_file,
                :file_reader,
                :tables,
                :clear_cache,
                :schema_version,
                :cache_file,
                :cache_tables,
                :migration_dir

    def initialize(options={})
      @file_reader   = options[:file_reader] ||= FileReader
      @schema_file   = options[:schema_file]

    end

    def search(model_name)
      @model_name = model_name
      load_table
      @tables
    end

    private

    def table_name
      model_name
    end

    def load_table
      eval_file
      raise "#{table_name} table not found." unless tables
    end

    def eval_file
      m = Module.new
      @tables = m.module_eval(read_file).tables
    end

    def read_file
      file_reader.read(schema_file)
    end

  end

  class SchemaVersion

    def self.migration_dir(dir)
      @migration_dir = dir || '/Users/zeisler/dev/active_mocker/spec/lib/active_mocker/performance/migration'
    end

    def self.get
      return @schema_version unless @schema_version.nil?
      r = Dir["#{@migration_dir}/*"].last
      p = Pathname.new(r)
      s = p.basename.to_s.match(/(\d*)_.*\.rb/).captures
      @schema_version = s.first
    end

  end

end

