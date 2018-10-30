# frozen_string_literal: true
module ActiveMocker
  module LateInclusion
    module Extension
      def prepended(const)
        if const.respond_to?(:__extended_onto__)
          const.__extended_onto__.each do |ex|
            ex.extend self
          end
        end

        if const.respond_to?(:__included_onto__)
          const.__included_onto__.each do |ex|
            ex.prepend self
          end
        end
      end
    end
    
    def extended(const)
      __extended_onto__ << const
    end

    def __extended_onto__
      @__extended_onto__ ||= []
    end

    def included(const)
      __included_onto__ << const
    end

    def __included_onto__
      @included_onto ||= []
    end
  end
end
