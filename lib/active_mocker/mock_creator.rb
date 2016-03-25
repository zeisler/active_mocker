module ActiveMocker
  class MockCreator
    def initialize(file:,
                   file_out:,
                   schema_scrapper:,
                   template_creator: nil,
                   class_introspector: nil,
                   enabled_partials: nil,
                   klasses_to_be_mocked:,
                   mock_append_name:,
                   active_record_base_klass: ActiveRecord::Base)
      @file                     = file
      @file_out                 = file_out
      @schema_scrapper          = schema_scrapper
      @template_creator         = template_creator || template_creator_default(file_out)
      @class_introspector       = class_introspector || class_introspector_default
      @enabled_partials         = enabled_partials || self.class.enabled_partials_default
      @klasses_to_be_mocked     = klasses_to_be_mocked
      @active_record_base_klass = active_record_base_klass
      @mock_append_name         = mock_append_name
      @errors                   = []
      @completed                = false
    end

    def create
      verify_class
      if errors.empty?
        begin
          template_creator.render
        rescue => e
          raise e unless error_already_collected?(e)
        end
        file_out.close
        @completed = true
      end
      self
    end

    def completed?
      @completed
    end

    attr_reader :errors

    private

    attr_reader :file,
                :file_out,
                :schema_scrapper,
                :template_creator,
                :class_introspector,
                :enabled_partials,
                :klasses_to_be_mocked,
                :active_record_base_klass,
                :mock_append_name

    def error_already_collected?(e)
      errors.any? { |eo| eo.original_error == e }
    end

    # -- Defaults -- #
    def template_creator_default(file_out)
      TemplateCreator.new(file_out:     file_out,
                          erb_template: File.new(File.join(File.dirname(__FILE__), "mock_template.erb"), 'r'),
                          binding:      binding,
                          post_process: -> (str) {
                            ruby_code = DissociatedIntrospection::RubyCode.build_from_source(str, parse_with_comments: true)
                            DissociatedIntrospection::WrapInModules.new(ruby_code: ruby_code)
                              .call(modules: nested_modules)
                              .source_from_ast.gsub(/end\n/, "end\n\n")
                          })
    end

    def class_introspector_default
      DissociatedIntrospection::Inspection.new(file: file)
    end

    class << self
      def enabled_partials_default
        [:modules_constants, :class_methods, :attributes, :scopes, :defined_methods, :associations]
      end

      public :enabled_partials_default
    end

    # -- END defaults -- #

    def verify_class
      v = ParentClass.new(parsed_source:        class_introspector.parsed_source,
                          klasses_to_be_mocked: klasses_to_be_mocked,
                          mock_append_name:     mock_append_name).call
      errors << v.error if v.error
      @parent_class = v.parent_mock_name
    end

    public

    def partials
      OpenStruct.new(enabled_partials.each_with_object({}) do |p, hash|
        begin
          file = File.new(File.join(File.dirname(__FILE__), "mock_template/_#{p}.erb"))
          self.extend("ActiveMocker::MockCreator::#{p.to_s.camelize}".constantize)
          hash[p] = ERB.new(file.read, nil, '-', "_sub#{p}").result(binding)
        rescue => e
          errors << ErrorObject.new(class_name: class_name, original_error: e, type: :generation, level: :error, message: e.message)
          errors << ErrorObject.new(class_name: class_name, original_error: e, type: :erb, level: :debug, message: "Erb template: #{p} failed.\n#{file.path}")
          raise e
        end
      end)
    end

    def class_name
      @class_name ||= class_introspector.parsed_source.class_name.split("::").last
    end

    def nested_modules
      @nested_modules ||= begin
        class_introspector.parsed_source.module_nesting.join("::")
      end
    end

    def parent_class
      @parent_class
    end

    def primary_key
      @primary_key ||= ActiveRecordSchemaScrapper::Attribute.new(name: 'id', type: :integer)
    end

    module ModulesConstants
      def constants
        class_introspector.get_class.constants.each_with_object({}) do |v, const|
          c        = class_introspector.get_class.const_get(v)
          const[v] = c unless c.class == Module || c.class == Class
        end
      end

      def modules
        @modules ||= begin
          {
            included: get_module_by_reference(:included_modules),
            extended: get_module_by_reference(:extended_modules)
          }
        end
      end

      private

      def get_module_by_reference(type)
        reject_local_const(class_introspector.public_send(type)).map(&:referenced_name)
      end

      def reject_local_const(source)
        source.reject do |n|
          class_introspector.locally_defined_constants.values.include?(n)
        end
      end
    end

    module Attributes
      def attributes
        @attribute ||= begin
          a = schema_scrapper.attributes.to_a
          unless a.any? { |aa| aa.name == "id" }
            a << primary_key
          end
          a
        end
      end
    end

    module ClassMethods
      include Attributes

      def attributes_with_defaults
        attributes.each_with_object({}) do |attr, hash|
          hash[attr.name] = Virtus::Attribute.build(attr.type).coerce(attr.default)
        end
      end

      def associations
        @associations ||= schema_scrapper.associations.to_a.each_with_object({}) do |a, h|
          h[a.name] = nil
        end
      end

      def associations_by_class
        schema_scrapper.associations.to_a.each_with_object({}) do |r, hash|
          hash[r.class_name.to_s]         ||= {}
          hash[r.class_name.to_s][r.type] ||= []
          hash[r.class_name.to_s][r.type] << r.name
        end
      end

      def attribute_names
        attributes.map { |a| a.name }
      end

      def abstract_class
        schema_scrapper.abstract_class?
      end

      def table_name
        schema_scrapper.table_name
      end

      def mocked_class
        [nested_modules, class_name].compact.reject(&:empty?).join("::")
      end
    end

    Method = Struct.new(:name, :arguments)

    module Scopes
      def scope_methods
        class_introspector.class_macros.select { |h| h.keys.first == :scope }.map do |h|
          a = h.values.first.first
          Method.new(a[0], ReverseParameters.new(a[1], blocks_as_values: true))
        end
      end
    end

    module DefinedMethods

      def instance_methods
        class_introspector
          .get_class
          .public_instance_methods(false)
          .sort
          .map { |m| create_method(m, :instance_method) }
      end

      def class_methods
        class_introspector
          .get_class
          .methods(false)
          .sort
          .map { |m| create_method(m, :method) }
      end

      private

      def create_method(m, type)
        Method.new(m, ReverseParameters.new(class_introspector.get_class.send(type, m).parameters, blocks_as_values: true))
      end
    end

    module Associations
      def has_many
        relation_find(:type, __method__)
      end

      def has_one
        relation_find(:type, __method__)
      end

      def belongs_to
        relation_find(:type, __method__)
      end

      def has_and_belongs_to_many
        relation_find(:type, __method__)
      end

      def relation_find(key, value)
        association_collection.select { |r| r.send(key).to_sym == value }
      end

      def association_collection
        @association_collection ||= schema_scrapper.associations.to_a
      end
    end
  end
end
