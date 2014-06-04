module ActiveMocker

  class LoadedMocks
    def self.add(mocks_to_add)
      mocks.merge!({mocks_to_add.name => mocks_to_add})
    end

    def self.all
      mocks
    end

    def self.clear_all
      mocks.each { |n, m| m.clear_mock }
    end

    def self.delete_all
      mocks.each { |n, m| m.delete_all }
    end

    def self.reload_all
      mocks.each { |n, m| m.reload }
    end

    def self.mocks
      @@mocks ||= {}
    end

    def self.undefine_all
      mocks.each do |n, m|
        Object.send(:remove_const, n) if Object.const_defined?(:n)
      end
    end
  end

end
