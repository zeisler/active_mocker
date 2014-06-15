class ObjectInspect

  def initialize(object)
    @string = object_for_inspect(object)
  end

  def to_s
    @string
  end

  def to_str
    @string
  end

  private

  def object_for_inspect(value)
    if value.is_a?(String) && value.length > 50
      "#{value[0, 50]}...".inspect
    elsif value.is_a?(Date) || value.is_a?(Time)
      %("#{value.to_s(:db)}")
    elsif value.is_a?(Array) && value.size > 10
      inspected = value.first(10).inspect
      %(#{inspected[0...-1]}, ...])
    else
      value.inspect
    end
  end


end