module ActiveMocker
  module V2
    class MockCreator
      def initialize(file:, file_out:, schema_scrapper:, template_creator: nil, attributes: nil, class_introspector: nil, enabled_partials: nil)
        @file               = file
        @file_out           = file_out
        @schema_scrapper    = schema_scrapper
        @template_creator   = template_creator || template_creator_default(file_out)
        @class_introspector = class_introspector || class_introspector_default
        @enabled_partials   = enabled_partials || enabled_partials_default
      end

      def create
        template_creator.render
        file_out.close
      end

      private

      attr_reader :file, :file_out, :schema_scrapper, :template_creator, :class_introspector, :enabled_partials

      # -- Defaults -- #
      private
      def template_creator_default(file_out)
        TemplateCreator.new(file_out:     file_out,
                            erb_template: File.new(File.join(File.dirname(__FILE__), "mock_template.erb"), 'r'),
                            binding:      binding)
      end

      def class_introspector_default
        DissociatedIntrospection::Inspection.new(file: file)
      end

      def enabled_partials_default
        [:modules_constants, :class_methods, :attributes, :scopes, :defined_methods]
      end

      # -- END defaults -- #

      public

      def partials
        OpenStruct.new(enabled_partials.each_with_object({}) do |p, hash|
                         begin
                           file    = File.new(File.join(File.dirname(__FILE__), "mock_template/_#{p}.erb"))
                           hash[p] = ERB.new(file.read, nil, '-', "_sub#{p}").result(binding)
                         rescue => e
                           print "#{file.path}"
                           raise e
                         end
                       end)
      end

      def class_name
        class_introspector.parsed_source.class_name
      end

      def mock_append_name
        'Mock'
      end

      def parent_class
        # return mock_name(call_method(:parent_class)) if call_method(:parent_class).present?
        'ActiveMocker::Mock::Base'
      end

      def attributes
        schema_scrapper.attributes.to_a
      end

      def constants
        const = {}
        class_introspector.get_class.constants.each { |c| const[c] = class_introspector.get_class.const_get(c) }
        const = const.reject do |c, v|
          v.class == Module || v.class == Class
        end
        const
      end

      def modules
        # TODO
        {included: [], extended: []}
      end

      def attributes_with_defaults
        hash = {}
        attributes.each do |attr|
          hash[attr.name] = attr.default
        end
        hash
      end

      def types_hash
        types = {}
        attributes.each do |attr|
          types[attr.name] = "#{attr.type}"
        end

        type_array = types.map do |name, type|
          "#{name}: #{type}"
        end
        '{ ' + type_array.join(', ') + ' }'
      end

      def associations
        schema_scrapper.associations.to_a.each_with_object({}) do |a, h|
          h[a.name] = nil
        end
      end

      def associations_by_class
        schema_scrapper.associations.to_a.each_with_object({}) do |r, hash|
          hash[r.class_name]         ||= {}
          hash[r.class_name][r.type] ||= []
          hash[r.class_name][r.type] << r.name
        end
      end

      def attribute_names
        attributes.map { |a| a.name }
      end

      def primary_key
        ActiveRecordSchemaScrapper::Attribute.new(name: 'id', type: :integer)
      end

      def abstract_class
        schema_scrapper.abstract_class?
      end

      def table_name
        schema_scrapper.table_name
      end

      def has_many
        []
      end

      def has_one
        []
      end

      def belongs_to
        []
      end

      def has_and_belongs_to_many
        []
      end

      def belongs_to_foreign_key(foreign_key)
        []
      end

      def scope_methods
        []
      end

      def instance_methods
        []
      end

      def class_methods(&class_methods_module_definition)
        []
      end
    end
  end
end