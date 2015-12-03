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
        template_creator.render
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
          print "#{file.inspect}"
          raise e
        end
      end)
    end

    def class_name
      class_introspector.parsed_source.class_name
    end

    def parent_class
      @parent_class
    end

    def primary_key
      @primary_key ||= ActiveRecordSchemaScrapper::Attribute.new(name: 'id', type: :integer)
    end

    module ModulesConstants
      def constants
        const = {}
        class_introspector.get_class.constants.each { |c| const[c] = class_introspector.get_class.const_get(c) }
        const = const.reject do |c, v|
          v.class == Module || v.class == Class
        end
        const
      end

      def modules
        @modules ||= begin
          {
            included: reject_local_const(class_introspector.included_modules)
                        .map(&:referenced_name),
            extended: reject_local_const(class_introspector.extended_modules)
                        .map(&:referenced_name)
          }
        end
      end

      private

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
        hash = {}
        attributes.each do |attr|
          hash[attr.name] = Virtus::Attribute.build(attr.type).coerce(attr.default)
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
    end

    module Scopes
      def scope_methods
        class_introspector.class_macros.select { |h| h.keys.first == :scope }.map do |h|
          a = h.values.first.first
          OpenStruct.new(name: a[0], arguments: ReverseParameters.new(a[1]))
        end
      end
    end

    module DefinedMethods
      def get_instance_methods
        methods = class_introspector.get_class.public_instance_methods(false)
        methods << class_introspector.get_class.superclass.public_instance_methods(false) if class_introspector.get_class.superclass != ActiveRecord::Base
        methods.flatten
      end

      def instance_methods
        get_instance_methods.map do |m|
          OpenStruct.new(name: m, arguments: ReverseParameters.new(class_introspector.get_class.instance_method(m).parameters))
        end
      end

      def get_class_methods
        class_introspector.get_class.methods(false)
      end

      def class_methods
        get_class_methods.map do |m|
          OpenStruct.new(name: m, arguments: ReverseParameters.new(class_introspector.get_class.method(m).parameters))
        end
      end
    end

    module Associations
      def has_many
        association_collection.select { |a| a.type == :has_many }
      end

      def has_one
        association_collection.select { |a| a.type == :has_one }
      end

      def belongs_to
        association_collection.select { |a| a.type == :belongs_to }
      end

      def has_and_belongs_to_many
        association_collection.select { |a| a.type == :has_and_belongs_to_many }
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