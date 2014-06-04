require 'rspec'

module ActiveMocker

  class ModelSchema

    attr_reader :class_name, :table_name, :attributes, :relationships, :methods
    def initialize( class_name:,
                    table_name:,
                    attributes:,
                    relationships:,
                    methods:
                  )
      @class_name = class_name
      @table_name = table_name
      @attributes = attributes
      @relationships = relationships
      @methods = methods
    end

  end

  class Attributes

    attr_reader :name, :type, :precision, :scale, :default_value
    def initialize( name:,
                    type:,
                    precision:,
                    scale:,
                    default_value:
                  )
      @name = name
      @type = type
      @precision = precision
      @scale = scale
      @default_value = default_value
    end
  end

end

describe ActiveMocker::ModelSchema do

  subject{described_class.new(class_name: 'Model',
                              table_name: 'models',
                              attributes: nil,
                              relationships: nil,
                              methods: nil)
  }

  it '#class_name' do
    expect(subject.class_name).to eq 'Model'
  end

  it '#table_name' do
    expect(subject.table_name).to eq 'models'
  end

  describe '#attributes' do

    describe 'name'
    describe 'type'
    describe 'precision'
    describe 'scale'
    describe 'default_value'

  end

  describe '#relationships' do

    describe 'name'
    describe 'class_name'
    describe 'type'
    describe 'through'
    describe 'foreign_key'
    describe 'join_table'

  end

  describe '#methods' do

    describe 'name'
    describe 'arguments'
    describe 'type'

  end

end