require_relative 'destroy_all'
require_relative 'update'

module ActiveHash

  module ARApi

    include ARApi::Update

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      include ARApi::DestroyAll
    end

  end

end



