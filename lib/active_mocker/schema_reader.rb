module ActiveMocker

  class SchemaReader

    attr_reader :model_name, :schema_file, :file_reader, :table

    def initialize(options={})
      @file_reader = options[:file_reader] ||= FileReader
      @schema_file = options[:schema_file]
    end

    def search(model_name)
      @model_name = model_name
      @table = search_schema_file
    end

    private

    def table_name
      model_name
    end

    def not_found
      raise "#{table_name} table not found." if @schema_result.nil?
    end

    def search_schema_file
      ActiveMocker::ActiveRecord::Schema.search(table_name)
      @schema_result = eval_file
      not_found
      @schema_result
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

