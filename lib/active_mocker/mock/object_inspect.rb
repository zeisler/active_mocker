module ActiveMocker
module Mock
class ObjectInspect

  def initialize(class_name, attributes)
    @class_name = class_name
    @attributes = attributes
    @string     = create_inspections
  end

  def to_s
    @string
  end

  def to_str
    @string
  end

  private

  def create_inspections
    inspection = @attributes.map do |name ,value|
      "#{name}: #{object_for_inspect(value)}"
    end
    "#<#{@class_name} #{inspection.compact.join(", ")}>"
  end

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
end
end