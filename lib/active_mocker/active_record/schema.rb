module ActiveMocker
  module ActiveRecord

    class Schema

      def self.define(version: version, &block)
        schema = SchemaParser.new
        schema.instance_eval(&block)
        {tables: schema.tables}
      end

    end

    class SchemaParser

      attr_reader :tables

      def initialize
        @tables = []
      end

      def create_table(name, force: force, &block)
        tables << {table_name: name, fields: CreateTable.new.instance_eval(&block)}
      end

      def method_missing(meth, *args)
      end

    end
  end

  class CreateTable

    attr_reader :fields

    def initialize
      @fields = []
    end

    def method_missing(meth, *args)
      base_field meth, args
    end

    def base_field(type, args)
      fields << {name: args.shift, type: type, options: args}
    end

  end

end


