# frozen_string_literal: true

require "active_mocker/inspectable"

module ActiveMocker
  class MockCreator
    using ActiveMocker::Inspectable
    ENABLED_PARTIALS_DEFAULT = %i[
      mock_build_version
      modules_constants
      class_methods
      attributes
      recreate_class_method_calls
      defined_methods
      scopes
      associations
    ].freeze

    # rubocop:disable Metrics/ParameterLists
    def initialize(file:,
                   file_out:,
                   schema_scrapper:,
                   template_creator: nil,
                   class_introspector: nil,
                   enabled_partials: nil,
                   klasses_to_be_mocked:,
                   mock_append_name:,
                   active_record_model:,
                   active_record_base_klass: ActiveRecord::Base)
      @file                     = file
      @file_out                 = file_out
      @schema_scrapper          = schema_scrapper
      @template_creator         = template_creator || template_creator_default(file_out)
      @class_introspector       = class_introspector || class_introspector_default
      @enabled_partials         = enabled_partials || ENABLED_PARTIALS_DEFAULT
      @klasses_to_be_mocked     = klasses_to_be_mocked
      @active_record_base_klass = active_record_base_klass
      @mock_append_name         = mock_append_name
      @active_record_model      = active_record_model
      @errors                   = []
      @completed                = false
    end

    def create
      verify_class
      render { file_out.close } if errors.empty?
      self
    end

    def render
      template_creator.render
    rescue => e
      raise e unless error_already_collected?(e)
    ensure
      yield
      @completed = true
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
                :mock_append_name,
                :active_record_model

    def error_already_collected?(e)
      errors.any? { |eo| eo.original_error == e }
    end

    # -- Defaults -- #
    def template_creator_default(file_out)
      TemplateCreator.new(file_out:     file_out,
                          erb_template: File.new(File.join(File.dirname(__FILE__), "mock_template.erb"), "r"),
                          binding:      binding,
                          post_process: lambda do |str|
                            ruby_code = DissociatedIntrospection::RubyCode.build_from_source(str,
                                                                                             parse_with_comments: true)
                            DissociatedIntrospection::WrapInModules.new(ruby_code: ruby_code)
                              .call(modules: nested_modules)
                              .source_from_ast.gsub(/end\n/, "end\n\n")
                          end)
    end

    def class_introspector_default
      DissociatedIntrospection::Inspection.new(file: file)
    end

    # -- END defaults -- #

    def parent_class_inspector
      @parent_class_inspector ||= ParentClass.new(parsed_source:        class_introspector.parsed_source,
                                                  klasses_to_be_mocked: klasses_to_be_mocked,
                                                  mock_append_name:     mock_append_name).call
    end

    def verify_parent_class
      errors << parent_class_inspector.error if parent_class_inspector.error
    end

    def verify_class
      verify_parent_class
    end

    def save_errors(e, file, p)
      errors << ErrorObject.new(class_name:     class_name,
                                original_error: e, type: :generation,
                                level:          :error,
                                message:        e.message)
      errors << ErrorObject.new(class_name:     class_name,
                                original_error: e,
                                type:           :erb,
                                level:          :debug,
                                message:        "Erb template: #{p} failed.\n#{file.path}")
    end

    public

    def partials
      OpenStruct.new(enabled_partials.each_with_object({}) do |p, hash|
        begin
          file = File.new(File.join(File.dirname(__FILE__), "mock_template/_#{p}.erb"))
          extend(ActiveMocker::MockCreator.const_get(p.to_s.camelize))
          hash[p] = ERB.new(file.read, nil, "-", "_sub#{p}").result(binding)
        rescue => e
          save_errors(e, file, p)
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

    def primary_key
      @primary_key ||= ActiveRecordSchemaScrapper::Attribute.new(name: "id", type: :integer)
    end
  end
end
