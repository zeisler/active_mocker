module ActiveMocker

  class SchemaReader

    attr_reader :model_name, :schema_file, :file_reader, :table, :clear_cache

    def initialize(options={})
      @file_reader = options[:file_reader] ||= FileReader
      @schema_file = options[:schema_file]
      @clear_cache = options[:clear_cache]
    end

    def search(model_name)
      @model_name = model_name
      @table = search_schema_file
      @table
      @table
    end

    private

    def table_name
      model_name
    end

    def search_schema_file
      ActiveMocker::ActiveRecord::Schema.clear_cache if clear_cache
      search_result = ActiveMocker::ActiveRecord::Schema.search(table_name)
      return search_result if search_result
      schema_result = eval_file
      raise "#{table_name} table not found." if schema_result.nil?
      schema_result
    end

    def eval_file
      m = Module.new
      m.module_eval(read_file)
    end

    def read_file
      file_reader.read(schema_file)
    end

  end

end

