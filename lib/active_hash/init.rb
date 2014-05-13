require 'active_support/core_ext/hash/indifferent_access'
module ActiveHash

  module ARApi

    module Init

      attr_reader :associations

      def initialize(attributes = {})
        filter_associations(HashWithIndifferentAccess.new(attributes))
        @attributes.dup.merge(@associations.dup).each do |key, value|
          send "#{key}=", value #maybe could just check if responds_to method? How AR works?
        end
      end

      private

      def filter_associations(attributes)
        permitted_params = [*self.class.send(:attribute_names), *self.class.send(:association_names)]
        rejected_params = attributes.reject{ |p| permitted_params.include? p.to_sym}
        raise "Rejected params: #{rejected_params} for #{self.class.name}" if !rejected_params.empty?
        @attributes = attributes.select do |k, v|
          self.class.send(:attribute_names).include? k.to_sym
        end
        @attributes = self.class.send(:attribute_template).merge(@attributes)
        @associations = attributes.select do |k, v|
          self.class.send(:association_names).include? k.to_sym
        end
        @associations = self.class.send(:association_template).merge(associations)

      end

    end
  end

end