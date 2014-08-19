require 'pathname'
module ActiveMocker
  # @api private
  class SchemaReader

    def tables
      load_table
    end

    private

    def load_table
      eval_file
      raise "#{table_name} table not found." unless @tables
      @tables
    end

    def eval_file
      m = Module.new
      @tables = m.module_eval(read_file).tables
    end

    def read_file
      Config.file_reader.read(Config.schema_file)
    end

  end

end

