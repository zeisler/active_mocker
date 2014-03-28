module Scope

  def scope(method_name, proc)
    public_class_methods_add method_name
  end

  def public_class_methods
    @@public_class_methods ||= []
    @@public_class_methods.uniq
  end

  def public_class_methods_add(method)
    public_class_methods
    @@public_class_methods << method
  end

end

