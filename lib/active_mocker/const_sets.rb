module ActiveMocker

  class ConstSets

    def initialize(string_of_consts, base_const=nil)

      Object.const_set('Foo','Foo')


    end

    def self.const_exists?(class_name)
      klass = Module.const_get(class_name)
      return klass.is_a?(Class)
    rescue NameError
      return false
    end

  end

end



