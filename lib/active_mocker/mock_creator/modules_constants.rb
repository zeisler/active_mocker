# frozen_string_literal: true
module ActiveMocker
  class MockCreator
    module ModulesConstants
      class Inspectable
        attr_reader :inspect

        def initialize(inspect)
          @inspect = inspect
        end
      end

      def modules
        @modules ||= begin
          {
            included: get_module_by_reference(:included_modules),
            extended: get_module_by_reference(:extended_modules),
          }
        end
      end

      def constants
        class_introspector.get_class.constants.each_with_object({}) do |v, const|
          c = class_introspector.get_class.const_get(v)
          next if [Module, Class].include?(c.class)
          const[v] = if /\A#</ =~ c.inspect
                       Inspectable.new("ActiveMocker::UNREPRESENTABLE_CONST_VALUE")
                     else
                       c
                     end
        end
      end

      def defined_nested_modules
        class_introspector.parsed_source.defined_nested_modules.map(&:source)
      end

      private
      def reject_local_const(source)
        source.reject do |n|
          class_introspector.locally_defined_constants.values.include?(n)
        end
      end

      def get_real_module(type)
        if type == :extended_modules
          active_record_model.singleton_class.included_modules
        else
          active_record_model.included_modules
        end
      end

      def get_module_by_reference(type)
        isolated_module_names = class_introspector.public_send(type).map(&:referenced_name)
        real_module_names     = get_real_module(type).map(&:name).compact
        isolated_module_names.map do |isolated_name|
          real_name = real_module_names.detect do |rmn|
            real_parts        = rmn.split("::")
            total_parts_count = active_record_model.name.split("::").count + isolated_name.split("::").count
            [
              real_parts.include?(active_record_model.name),
              real_parts.include?(isolated_name),
              (total_parts_count == real_parts.count),
            ].all?
          end
          real_name ? real_name : isolated_name
        end
      end
    end
  end
end
