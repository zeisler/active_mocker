# frozen_string_literal: true

module ActiveMocker
  class HashNewStyle < Hash
    def inspect
      "{ " + map { |name, type| "#{name}: #{type}" }.join(", ") + " }"
    end
  end
end
