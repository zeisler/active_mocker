# frozen_string_literal: true

module ActiveMocker
  module MockableMethod
    private

    def __am_raise_not_mocked_error(method:, caller:, type:)
      variable_name = if is_a?(Relation)
                        "#{self.class.name.underscore.split("/").first}_relation"
                      elsif type == "#"
                        "#{self.class.name.underscore}_record"
                      else
                        name
                      end

      message = <<-ERROR.strip_heredoc
        Unknown implementation for mock method: #{variable_name}.#{method}
        Stub method to continue.

        RSpec:
          allow(
            #{variable_name}
          ).to receive(:#{method}).and_return(:some_expected_result)
      ERROR

      raise NotImplementedError, message, caller
    end
  end
end
