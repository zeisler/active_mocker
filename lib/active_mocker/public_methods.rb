module ActiveMocker

  def self.mock(model_name)
    Generate.mock(model_name)
  end

  def self.configure(&block)
    Generate.configure(&block)
  end

  def self.config(&block)
    Generate.configure(&block)
  end

end