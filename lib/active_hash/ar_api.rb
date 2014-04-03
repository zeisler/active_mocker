require_relative 'destroy_all'
require_relative 'update'
require_relative 'find_by'

module ActiveHash

  module ARApi

    include ARApi::Update

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      include ARApi::DestroyAll
      include ARApi::FindBy
    end

  end

end



