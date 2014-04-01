module Scope

  def scope(method_name, proc)
    singleton_class.class_eval do
      params = Reparameterize.call(proc.parameters)
      block = eval("lambda { |#{params}| }")
      define_method(method_name, block)
    end
  end

end

