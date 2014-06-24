module ActiveMocker
module Mock
module DoNothingActiveRecordMethods

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods

    def transaction
      yield
    rescue LocalJumpError => err
      raise err
    rescue StandardError => e
      raise e
    end

    def column_names
      attribute_names
    end

  end

  def readonly?
    false
  end

  def errors
    obj = Object.new

    def obj.[](key)
      []
    end

    def obj.full_messages()
      []
    end

    obj
  end

  def valid?
    true
  end

  def marked_for_destruction?
    false
  end

  def destroyed?
    false
  end

end
end
end