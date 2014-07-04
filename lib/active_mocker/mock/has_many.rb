module ActiveMocker
module Mock

  class HasMany < Association

    include Queries

    def self.new(collection, foreign_key=nil, foreign_id=nil, relation_class=nil)
      return Relation.new(collection) if relation_class.nil?
      super
    end

    def initialize(collection, foreign_key, foreign_id, relation_class)
      @relation_class = relation_class
      @foreign_key    = foreign_key
      @foreign_id     = foreign_id
      self.class.include "#{relation_class.name}::Scopes".constantize
      super(collection)
    end

    private
    attr_reader :relation_class, :foreign_key, :foreign_id
    public

    def build(options={}, &block)
      new_record = relation_class.new(init_options.merge!(options), &block)

      def new_record.belongs_to(collection)
        @belongs_to_collection = collection
      end

      new_record.belongs_to(self)

      def new_record.save
        @belongs_to_collection << self
        super
      end

      new_record
    end

    def create(options={}, &block)
      created_record = relation_class.create(init_options.merge!(options), &block)
      collection << created_record
      created_record
    end

    alias_method :create!, :create

    def init_options
      {foreign_key => foreign_id}
    end

    private :init_options

  end

end
end

