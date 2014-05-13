module ActiveMocker

  def self.mock(model_name)
    Base.mock(model_name)
  end

  def self.configure(&block)
    Base.configure(&block)
    Generate.configure(&block)
  end

end