# frozen_string_literal: true
module ActiveMocker
  class BaseError < StandardError
  end
  class RecordNotFound < BaseError
  end

  module Mock
    # @deprecated
    RecordNotFound = ActiveMocker::RecordNotFound
  end

  class IdError < BaseError
  end

  # Raised when unknown attributes are supplied via mass assignment.
  class UnknownAttributeError < NoMethodError
    attr_reader :record, :attribute

    def initialize(record, attribute)
      @record    = record
      @attribute = attribute.to_s
      super("unknown attribute: #{attribute}")
    end
  end

  class UpdateMocksError < BaseError
    def initialize(name, mock_version, gem_version)
      super("#{name} was built with #{mock_version} but the gem version is #{gem_version}. Run `rake active_mocker:build` to update.")
    end
  end

  class NotImplementedError < BaseError
  end

  class Error < BaseError
  end

  class MockNotLoaded < BaseError
  end
end
