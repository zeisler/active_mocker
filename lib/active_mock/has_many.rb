module ActiveMock

  class HasMany < Association

    include Queries

    def self.new(collection, foreign_key=nil, foreign_id=nil, relation_class=nil)
      return Association.new(collection) if relation_class.nil? || !Object.const_defined?(relation_class)
      super(collection, foreign_key, foreign_id, relation_class)
    end


    def initialize(collection, foreign_key=nil, foreign_id=nil, relation_class=nil)
      @relation_class = relation_class.constantize
      @foreign_key    = foreign_key
      @foreign_id     = foreign_id

      super(collection)
      if !foreign_id.nil? && collection.first.respond_to?(foreign_key)
        update_all("#{foreign_key}" => foreign_id)
      end
    end

    private
    attr_reader :relation_class, :foreign_key, :foreign_id
    public

    def build(options={}, &block)
      new_record = relation_class.new({foreign_key => foreign_id}.merge!(options), &block)

      def new_record.owned_by=(collection)
        @collection = collection
      end

      new_record.owned_by = @collection

      def new_record.save
        @collection << self
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

