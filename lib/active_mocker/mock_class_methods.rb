module ActiveMocker
module MockClassMethods

  def mock_instance_method(method, &block)
    model_instance_methods[method.to_s] = block
  end

  def mock_class_method(method, &block)
    model_class_methods[method.to_s] = block
  end

  def column_names
    schema_attributes_template
  end

  private

  def delegate_to_model_instance(method, *args)
    model_class_instance.send(method, *args)
  end

  def delegate_to_model_class(method, *args)
    model_class.send(method, *args)
  end

  def model_class_methods
    @model_class_methods ||= HashWithIndifferentAccess.new
  end

  def model_methods_template
    @model_methods_template ||= HashWithIndifferentAccess.new
  end

  def schema_attributes_template
    @schema_attributes_template ||= HashWithIndifferentAccess.new
  end

  def model_class
    @model_class
  end

  def model_class_instance
    @model_class_instance ||= model_class.new
  end

  def attribute_names
    @attribute_names
  end

  def attribute_names=(attributes)
    @attribute_names = attributes.map{|a| a.to_sym}
  end

  def attribute_template
    return @attribute_template unless @attribute_template.nil?
    @attribute_template = HashWithIndifferentAccess.new
    attribute_names.each {|a| @attribute_template[a] = nil}
    return @attribute_template
  end

  def association_names
    @association_names
  end

  def association_names=(associations)
    @association_names = associations.map{|a| a.to_sym}
  end

  def association_template
    return @association_template unless @association_template.nil?
    @association_template = HashWithIndifferentAccess.new
    association_names.each {|a| @association_template[a] = nil}
    return @association_template
  end

  def set_type(field_name, type)
    types[field_name] = Virtus::Attribute.build(type)
  end

  def coerce(field, new_val)
    type = self.class.types[field]
    return attributes[field] = type.coerce(new_val) unless type.nil?
    return new_value
  end

  public
  def is_implemented(val, method)
    raise "#{method} is not Implemented for Class: #{name}" if val == :not_implemented
  end

end
end