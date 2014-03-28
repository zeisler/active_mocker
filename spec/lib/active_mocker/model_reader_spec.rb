require 'rspec'
$:.unshift File.expand_path('../../', __FILE__)

require 'active_mocker/active_record'
require 'active_mocker/model_reader'

describe ActiveMocker::ModelReader do

  let(:new){ described_class.new('model', File.expand_path('../../', __FILE__)) }

  describe '#new' do

    it 'takes a model name to the active_record model class' do
      new
    end

  end


  describe '#class_methods' do

    it 'returns all public class methods' do
      expect(new.class_methods).to eq([:duper, :named])
    end

  end

  describe '#instance methods' do

    it 'returns all public instance methods' do
      expect(new.instance_methods).to eq([:foo, :super])
    end

  end

  describe '#relationships' do

    it '#belongs_to' do

      expect(new.relationships.belongs_to).to eq([[:company]])

    end

    it '#has_many' do

      expect(new.relationships.has_many).to eq([[:users]])

    end

    it '#has_one' do

      expect(new.relationships.has_one).to eq([[:account]])

    end

    it '#has_and_belongs_to_many' do

      expect(new.relationships.has_and_belongs_to_many).to eq([[:disclosure]])

    end

  end


end

