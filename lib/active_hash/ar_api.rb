require_relative 'update'
require_relative 'find_by'
require_relative 'init'
module ActiveMocker
  module ActiveHash

    module ARApi

      include ::ActiveHash::ARApi::Update
      include ::ActiveHash::ARApi::Init

      def delete
        self.class.send(:record_index).delete("#{self.id}")
        records = self.class.instance_variable_get(:@records)
        index = records.index(self)
        records.delete_at(index)
      end

      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        include ::ActiveHash::ARApi::FindBy

        def find_or_create_by(attributes)
          find_by(attributes) || create(attributes)
        end

        def find_or_initialize_by(attributes)
          find_by(attributes) || new(attributes)
        end

        def delete(id)
          find(id).delete
        end

        alias_method :destroy, :delete

        def delete_all(options=nil)
          return super() if options.nil?
          where(options).map{|r| r.delete}.count
        end

        alias_method :destroy_all, :delete_all

      end

    end



  end

end



