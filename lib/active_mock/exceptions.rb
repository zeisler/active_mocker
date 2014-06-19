module ActiveMock
  class RecordNotFound < StandardError
  end

  class ReservedFieldError < StandardError
  end

  class IdError < StandardError
  end

  class FileTypeMismatchError < StandardError
  end

  class RejectedParams < Exception
  end

  class Unimplemented < Exception
  end
end
