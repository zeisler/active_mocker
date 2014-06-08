require 'rspec'
$:.unshift File.expand_path('../../../../lib', __FILE__)
require 'json'
require_relative '../../unit_logger'
require 'active_mocker/model_schema'

describe ActiveMocker::ModelSchema, pending: true do

  subject{described_class.new(class_name: 'Model',
                              table_name: 'models'
                              )
          }

  it '#class_name' do
    expect(subject.class_name).to eq 'Model'
  end

  it '#table_name' do
    expect(subject.table_name).to eq 'models'
  end

  describe '#attributes -> Array' do

    subject { described_class.new(
                   attributes: [ActiveMocker::ModelSchema::Attributes.new(name: 'name',
                                                             type: :string,
                                                             precision: nil,
                                                             scale: nil,
                                                             default_value: 'default'
                                                            )]
                                  ).attributes.first
    }

    it 'name' do
      expect(subject.name).to eq 'name'
    end

    it 'type' do
      expect(subject.type).to eq :string
    end

    it 'precision' do
      expect(subject.precision).to eq nil
    end

    it 'scale' do
      expect(subject.scale).to eq nil
    end

    it 'default_value' do
      expect(subject.default_value).to eq 'default'
    end

  end

  describe '#relationships -> Array' do

    subject { described_class.new(
                relationships:
                    [
                      ActiveMocker::ModelSchema::Relationships.new(name:       'name',
                                                      class_name: 'ClassName',
                                                      type:       'Relationship Type',
                                                      through:    'link',
                                                      foreign_key:'relationship_id',
                                                      join_table: 'join_table'
                                                      )
                    ]
             ).relationships.first
    }

    it 'name' do
      expect(subject.name).to eq 'name'
    end

    it 'class_name' do
      expect(subject.class_name).to eq 'ClassName'
    end

    it 'type' do
      expect(subject.type).to eq 'Relationship Type'
    end

    it 'through' do
      expect(subject.through).to eq 'link'
    end

    it 'foreign_key' do
      expect(subject.foreign_key).to eq 'relationship_id'
    end

    it 'join_table' do
      expect(subject.join_table).to eq 'join_table'
    end

  end

  describe '#methods -> Array' do

    subject { described_class.new(
            methods:
            [
                ActiveMocker::ModelSchema::Methods.new(name:      'method_name',
                                          arguments: 'argument_array',
                                          type:      'class_method'
                                          )
            ]
            ).methods.first
    }

    it 'name' do
      expect(subject.name).to eq 'method_name'
    end

    it 'arguments' do
      expect(subject.arguments).to eq 'argument_array'
    end

    it 'type' do
      expect(subject.type).to eq 'class_method'
    end

  end

end