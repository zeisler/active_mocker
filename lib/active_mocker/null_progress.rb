# frozen_string_literal: true
module ActiveMocker
  class NullProgress
    def self.create(*)
      new
    end

    def initialize(*)
    end

    def increment
    end
  end
end
