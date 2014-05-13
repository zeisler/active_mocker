module ActiveMocker
module MockInstanceMethods

  def mock_instance_method(method, &block)
    model_instance_methods[method] = block
  end

  def inspect
    inspection =  self.class.column_names.map { |name|
      "#{name}: #{attribute_for_inspect(name)}"
    }.compact.join(", ")

    "#<#{self.class} #{inspection}>"
  end

  def attribute_for_inspect(attr_name)
    value = self.attributes[attr_name]
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

  def hash
    attributes.hash
  end

  def ==(obj)
    hash == obj.attributes.hash
  end

  private

  def read_attribute(attr)
    attributes[attr]
  end

  def write_attribute(attr, value)
    attributes[attr] = value
  end

  def read_association(attr)
    @associations[attr]
  end

  def write_association(attr, value)
    @associations[attr] = value
  end

  def attribute_to_string
    attributes.map {|k, v| "#{k.to_s}: #{v.inspect}"}.join(', ')
  end

  def delegate_to_model_instance(method, *args)
    self.class.send(:delegate_to_model_instance, method, *args)
  end

  def delegate_to_model_class(method, *args)
    self.class.send(:delegate_to_model_class, method, *args)
  end

  def model_instance_methods
    @model_instance_methods ||= self.class.send(:model_instance_methods).dup
  end

  def model_class_methods
    @model_class_methods ||= self.class.send(:model_class_methods).dup
  end

  def schema_attributes
    @schema_attributes ||= self.class.send(:attribute_template).dup
  end

end
end