module ActiveMocker

  def self.mock(model_name, force_reload: false)
    Generate.mock(model_name, force_reload: force_reload)
  end

  def self.configure(&block)
    Generate.configure(&block)
  end

  def self.config(&block)
    Generate.configure(&block)
  end

end