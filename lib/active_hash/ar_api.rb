require_relative 'init'
require_relative '../active_mocker/collection/queries'
require_relative '../active_mocker/collection/base'
require_relative '../active_mocker/collection/relation'
require_relative '../active_mocker/collection/creators'
module ActiveMocker
  module ActiveHash

    module ARApi

      include ::ActiveHash::ARApi::Init

      def delete
        self.class.send(:record_index).delete("#{self.id}")
        records = self.class.instance_variable_get(:@records)
        index = records.index(self)
        records.delete_at(index)
      end

      def update(options={}, &block)
        yield self if block_given?

        options.each do |key, value|
          begin
            send "#{key}=", value
          rescue NoMethodError => e
            puts e
            puts $!.backtrace
            raise ActiveMocker::RejectedParams, "{:#{key}=>#{value.inspect}} for #{self.class.name}"
          end
        end

      end

      def readonly?
        false
      end

      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        include ActiveMocker::Collection::Queries
        include ActiveMocker::Collection::Creators

        def delete(id)
          find(id).delete
        end

        def to_a
          @records
        end

        alias_method :destroy, :delete

        def delete_all(options=nil)
          return where(options).map{|r| r.delete}.count unless options.nil?
          mark_dirty
          reset_record_index
          @records = []
        end

        alias_method :destroy_all, :delete_all

      end

    end

  end

end