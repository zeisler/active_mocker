module ActiveMocker

  class LoadedMocks
    def self.add(mocks_to_add)
      mocks.merge!({mocks_to_add.name => mocks_to_add})
    end

    def self.add_subclass(subclass)
      subclasses.merge!({subclass.mocked_class => subclass})
    end

    def self.subclasses
      @subclasses ||= {}
    end

    def self.clear_subclasses
      @subclasses = nil
    end

    def self.mocks
      @mocks ||= {}
    end

    def self.find(klass)
      class_name_to_mock[klass]
    end

    def self.all
      mocks
    end

    def self.clear_all
      action = -> (mocks){ mocks.each { |n, m| m.clear_mock } }
      action.call(mocks)
      action.call(subclasses)
      clear_subclasses
    end

    def self.delete_all
      action = -> (mocks) { mocks.each { |n, m| m.delete_all } }
      action.call(mocks)
      action.call(subclasses)
    end

    def self.reload_all
      action = -> (mocks) { mocks.each { |n, m| m.send(:reload) } }
      action.call(mocks)
      action.call(subclasses)
    end

    def self.undefine_all
      action = -> (mocks) { mocks.each do |n, m|
        Object.send(:remove_const, n) if Object.const_defined?(n)
      end }
      action.call(mocks)
      action.call(subclasses)
    end

    def self.class_name_to_mock
      hash = {}
      mocks.each do |mock_name, mock_constant|
        hash[mock_constant.mocked_class] = mock_constant
      end
      hash.merge(subclasses)
    end

    private

    def self.internal_clear
      clear_subclasses
      @mocks = nil
    end
  end

end
