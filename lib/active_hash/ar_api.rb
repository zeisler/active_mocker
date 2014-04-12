require_relative 'destroy_all'
require_relative 'update'
require_relative 'find_by'
require_relative 'init'

module ActiveHash

  module ARApi

    include ARApi::Update
    include ARApi::Init

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      include ARApi::DestroyAll
      include ARApi::FindBy

      def find_or_create_by(attributes)
        find_by(attributes) || create(attributes)
      end

      def find_or_initialize_by(attributes)
        find_by(attributes) || new(attributes)
      end
    end

  end

end



