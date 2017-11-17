# frozen_string_literal: true

module ActiveMocker
  module MockableMethod
    private

    def __am_raise_not_mocked_error(method:, caller:, type:)
      variable_name, klass, method_type = if is_a?(Relation)
                                            klass = self.class.name.underscore.split("/").first
                                            ["#{klass}_relation", klass.camelize, :scopes]
                                          elsif type == "#"
                                            klass = self.class.name
                                            ["#{klass.underscore}_record", klass, :instance_methods]
                                          else
                                            [name, name, :class_methods]
                                          end

      message = <<-ERROR.strip_heredoc
        Unknown implementation for mock method: #{variable_name}.#{method}
        Stub method to continue.

        RSpec:
          allow(
            #{variable_name}
          ).to receive(:#{method}).and_return(:some_expected_result)

        OR Whitelist the method as safe to copy/run in the context of ActiveMocker (requires mock rebuild)
        # ActiveMocker.safe_methods #{method_type}: [:#{method}]
        class #{klass.gsub("Mock", "")} < ActiveRecord::Base
        end
      ERROR

      raise NotImplementedError, message, caller
    end
  end
end
