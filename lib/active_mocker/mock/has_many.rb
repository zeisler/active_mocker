module ActiveMocker
module Mock

  class HasMany < Association

    include Queries

    def self.new(collection, foreign_key=nil, foreign_id=nil, relation_class=nil)
      return Association.new(collection) if relation_class.nil?
      super(collection, foreign_key, foreign_id, relation_class)
    end


    def initialize(collection, foreign_key=nil, foreign_id=nil, relation_class=nil)
      @relation_class = relation_class
      @foreign_key    = foreign_key
      @foreign_id     = foreign_id

      super(collection)
    end

    private
    attr_reader :relation_class, :foreign_key, :foreign_id
    public

    def build(options={}, &block)
      new_record = relation_class.new({foreign_key => foreign_id}.merge!(options), &block)

      def new_record.belongs_to(collection, foreign_key)
        @belongs_to_collection ||={}
        @belongs_to_collection[foreign_key] = collection
      end

      new_record.belongs_to(self, foreign_key)

      def new_record.save
        @belongs_to_collection.each {|k ,v| v << self}
        super
      end

      new_record
    end

    def create(options={}, &block)
      created_record = relation_class.create({foreign_key => foreign_id}.merge!(options), &block)
      collection << created_record
      created_record
    end

    alias_method :create!, :create

  end

end
end

