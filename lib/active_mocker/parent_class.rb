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
      if has_parent_class?
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
        'ActiveMocker::Base'
      end
    end

    private
    attr_reader :parsed_source,
                :klasses_to_be_mocked,
                :active_record_base_klass,
                :mock_append_name

    def deal_with_parent
      if parent_class <= active_record_base_klass
        @parent_mock_name = parent_class_name if klasses_to_be_mocked.include?(parent_class_name)
      else
        create_error("#{class_name} does not inherit from ActiveRecord::Base")
      end
    end

    def create_error(message)
      @error = OpenStruct.new(class_name: class_name,
                              message:    message)
    end

    def has_parent_class?
      parsed_source.has_parent_class?
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
  end
end