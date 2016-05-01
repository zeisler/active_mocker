# frozen_string_literal: true
module ActiveMocker
  class HasMany < Association
    include Queries

    def self.new(collection, options = {})
      return Relation.new(collection) if options[:relation_class].nil?
      super(collection, options)
    end

    def initialize(collection, options = {})
      @relation_class = options[:relation_class]
      @foreign_key    = options[:foreign_key]
      @foreign_id     = options[:foreign_id]
      @source         = options[:source]
      self.class.include "#{@relation_class.name}::Scopes".constantize
      super(collection)
      set_foreign_key
    end

    def set_foreign_key
      collection.each do |item|
        item.send(:write_attribute, foreign_key, foreign_id) if item.respond_to?("#{foreign_key}=")
      end
    end

    # @api private
    attr_reader :relation_class, :foreign_key, :foreign_id, :source

    def build(options = {}, &block)
      new_record = relation_class.new(init_options.merge!(options), &block)

      # @private
      def new_record._belongs_to(collection)
        @belongs_to_collection = collection
      end

      new_record._belongs_to(self)

      # @private
      def new_record.save
        @belongs_to_collection << self
        super
      end

      new_record
    end

    def create(options = {}, &block)
      created_record = relation_class.create(init_options.merge!(options), &block)
      collection << created_record
      created_record
    end

    alias create! create

    # @api private
    def init_options
      { foreign_key => foreign_id }
    end
  end
  module Mock
    # @deprecated
    HasMany = ActiveMocker::HasMany
  end
end
