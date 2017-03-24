# frozen_string_literal: true
module ActiveMocker
  class ParentClass
    def initialize(parsed_source:, klasses_to_be_mocked:, mock_append_name:, active_record_base_klass: ::ActiveRecord::Base)
      @parsed_source            = parsed_source
      @klasses_to_be_mocked     = klasses_to_be_mocked
      @active_record_base_klass = active_record_base_klass
      @mock_append_name         = mock_append_name
    end

    attr_reader :error

    def call
      if parent_class?
        deal_with_parent
      else
        create_error("#{class_name} is missing a parent class.")
      end
      self
    end

    def parent_mock_name
      if @parent_mock_name
        "#{@parent_mock_name}#{mock_append_name}"
      else
        "ActiveMocker::Base"
      end
    end

    private

    attr_reader :parsed_source,
                :klasses_to_be_mocked,
                :active_record_base_klass,
                :mock_append_name

    def deal_with_parent
      if parent_class <= active_record_base_klass
        @parent_mock_name = parent_class_name if included_mocked_class?
      else
        create_error("#{class_name} does not inherit from ActiveRecord::Base")
      end
    end

    def create_error(message)
      @error = OpenStruct.new(class_name: class_name,
                              message:    message)
    end

    def parent_class?
      parsed_source.parent_class?
    end

    def parent_class_name
      parsed_source.parent_class_name
    end

    def class_name
      parsed_source.class_name
    end

    def parent_class
      parent_class_name.constantize
    end

    def included_mocked_class?
      sanitize_consts(klasses_to_be_mocked).include?(sanitize_consts(parent_class_name).first)
    end

    def sanitize_consts(consts)
      [*consts].map do |const|
        const.split("::").reject(&:empty?).join("::")
      end
    end
  end
end
