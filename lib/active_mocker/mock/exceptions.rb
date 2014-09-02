module ActiveMocker
module Mock
  class RecordNotFound < StandardError
  end

  class ReservedFieldError < StandardError
  end

  class IdError < StandardError
  end

  class FileTypeMismatchError < StandardError
  end

  # Raised when unknown attributes are supplied via mass assignment.
  class UnknownAttributeError < NoMethodError

    attr_reader :record, :attribute

    def initialize(record, attribute)
      @record = record
      @attribute = attribute.to_s
      super("unknown attribute: #{attribute}")
    end

  end

  class NotImplementedError < Exception
  end

  class IdNotNumber < Exception
  end

  class Error < Exception
  end

end
end
