module ActiveMocker
  class NullProgress

    def self.create(*)
      self.new
    end

    def initialize(*)
    end

    def increment
    end
  end
end
