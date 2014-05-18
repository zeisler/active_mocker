module ActiveMocker

  def self.mock(model_name, options=nil)
    Generate.mock(model_name)
  end

  def self.configure(&block)
    Generate.configure(&block)
  end

  def self.config(&block)
    Generate.configure(&block)
  end

  def self.create_mocks
    Generate.new
  end

end