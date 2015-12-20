module ActiveMocker
  class HashNewStyle < Hash
    def inspect
      '{ ' + self.map { |name, type| "#{name}: #{type}" }.join(', ') + ' }'
    end
  end
end
