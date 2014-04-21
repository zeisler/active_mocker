module ActiveMocker
  module ActiveRecord

    class Schema

      def self.define(options, &block)
        version = options[:version]
        search_result = search_cache(@table_search)
        search_result unless search_result.nil?
        schema = parse
        schema.instance_eval(&block)
        add_to_cache schema.tables.first
        schema.tables.first
      end

      def self.parse
        SchemaParser.new(@table_search)
      end

      def self.add_to_cache(table)
        @tables_cache ||= []
        @tables_cache << table unless table.nil?
      end

      def self.search_cache(table_name)
        @tables_cache ||= []
        @tables_cache.find do |h|
          h.name == table_name
        end
      end

      def self.clear_cache
        @tables_cache = []
      end

      def self.search(table_name)
        @table_search = table_name
        search_cache(table_name)
      end

    end

    class SchemaParser

      attr_reader :tables, :table_search

      def initialize(table_search)
        @table_search = table_search
        @tables = []

      end

      def create_table(name, options={}, &block)
        tables << ActiveMocker::Table.new(name, CreateTable.new.instance_eval(&block)) if name == table_search
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
      fields << Field.new(args.shift, type, args)
    end

  end

end


