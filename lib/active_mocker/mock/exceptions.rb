# frozen_string_literal: true
module ActiveMocker
  class RecordNotFound < StandardError
  end

  module Mock
    # @deprecated
    RecordNotFound = ActiveMocker::RecordNotFound
  end

  class IdError < StandardError
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

  class UpdateMocksError < Exception
    def initialize(name, mock_version, gem_version)
      super("#{name} was built with #{mock_version} but the gem version is #{gem_version}. Run `rake active_mocker:build` to update.")
    end
  end

  class NotImplementedError < Exception
  end

  class Error < Exception
  end
end
