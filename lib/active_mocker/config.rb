# frozen_string_literal: true
module ActiveMocker
  class Config
    class << self
      attr_accessor :model_dir,
                    :mock_dir,
                    :single_model_path,
                    :progress_bar,
                    :error_verbosity,
                    :disable_modules_and_constants,
                    :mock_append_name

      attr_writer :model_base_classes

      # @see ActiveMocker#configure
      def set
        load_defaults
        yield self
      end

      def load_defaults
        @error_verbosity               = 1
        @progress_bar                  = true
        @disable_modules_and_constants = false
        @model_dir                     = nil unless @model_dir
        @mock_dir                      = nil unless @mock_dir
        @mock_append_name              = "Mock"
        rails_defaults if Object.const_defined?("Rails")
      end

      def reset_all
        [:model_dir,
         :mock_dir,
         :log_location,
         :single_model_path,
         :progress_bar,
         :error_verbosity,
         :mock_append_name,
        ].each { |ivar| instance_variable_set("@#{ivar}", nil) }
      end

      def rails_defaults
        @model_dir = File.join(Rails.root, "app/models") unless @model_dir
        @mock_dir  = File.join(Rails.root, "spec/mocks") unless @mock_dir
      end

      def progress_class
        @progress_bar ? Progress : NullProgress
      end
    end
  end
end
