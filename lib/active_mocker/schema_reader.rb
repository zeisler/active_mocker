require 'pathname'
module ActiveMocker
  class SchemaReader

    attr_reader :model_name,
                :schema_file,
                :file_reader,
                :table,
                :clear_cache,
                :schema_version,
                :cache_file,
                :cache_tables,
                :migration_dir

    def initialize(options={})
      @file_reader   = options[:file_reader] ||= FileReader
      @schema_file   = options[:schema_file]
      @clear_cache   = options.fetch(:clear_cache,  true)
      @cache_tables  = options.fetch(:cache_tables, true)
      @migration_dir = options.fetch(:migration_dir, '/Users/zeisler/dev/active_mocker/spec/lib/active_mocker/performance/migration')
      SchemaVersion.migration_dir(migration_dir) if cache_tables
      get_schema_version if cache_tables
      clear_caches
    end

    def search(model_name)
      @model_name = model_name
      load_table
      @table
    end

    private

    def get_schema_version
      @schema_version = SchemaVersion.get
    end

    def table_name
      model_name
    end

    def load_table
      return table if search_in_memory
      return table if load_from_cache_file
      save_to_cache_file if eval_file
      raise "#{table_name} table not found." unless table
    end

    def clear_caches
      if clear_cache
        ActiveMocker::ActiveRecord::Schema.clear_cache
        FileUtils.rm_rf("schema_mashal/.", secure: true)
      end
    end

    def search_in_memory
      table = ActiveMocker::ActiveRecord::Schema.search(table_name)
      @table = table
    end

    def load_from_cache_file
      return false unless File.exist? "schema_mashal/#{schema_version}_#{table_name}.marshal"
      result = Marshal.load(File.open("schema_mashal/#{schema_version}_#{table_name}.marshal").read)
      ActiveMocker::ActiveRecord::Schema.add_to_cache(result)
      @table = result
    end

    def save_to_cache_file
      File.open("schema_mashal/#{schema_version}_#{table_name}.marshal", 'w'){|file| file.write(Marshal.dump(table))}
    end

    def eval_file
      m = Module.new
      @table = m.module_eval(read_file)
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

