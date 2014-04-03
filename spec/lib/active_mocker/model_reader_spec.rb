require 'rspec'
$:.unshift File.expand_path('../../', __FILE__)
require 'logger'
require 'active_mocker/logger'
require 'string_reader'
require 'file_reader'
require 'active_mocker/logger'
require 'active_mocker/active_record'
require 'active_mocker/model_reader'
require 'active_mocker/reparameterize'

describe ActiveMocker::ModelReader do

  let(:subject){ described_class.new({model_dir: File.expand_path('../../', __FILE__)}).parse('model') }

  describe '#parse' do

    let(:subject){ described_class.new({model_dir: File.expand_path('../../', __FILE__)}) }

    it 'takes a model name to the active_record model class' do
      subject.parse('Model')
    end

  end

  describe '#class_methods' do

    it 'returns all public class methods' do
      expect(subject.class_methods).to eq([:duper, :named, :foo, :bang!])
    end

  end

  describe '#instance methods' do

    it 'returns all public instance methods' do
      expect(subject.instance_methods).to eq([:foo, :super])
    end

  end

  describe '#instance_methods_with_arguments' do

    it 'returns all public instance methods' do
      expect(subject.instance_methods_with_arguments).to eq([{:foo=>[[:req, :foobar], [:req, :value]]}, {:super=>[]}])
    end

  end

  describe '#class_methods_with_arguments' do

    it 'returns all public instance methods' do
      expect(subject.class_methods_with_arguments).to eq( [{:duper=>[[:req, :value], [:rest, :args]]}, {:named=>[[:req, :name], [:opt, :value], [:opt, :options]]}, {:foo=>[]}, {:bang! =>[]}])
    end

  end

  describe '#relationships_types' do

    it '#belongs_to' do

      expect(subject.relationships_types.belongs_to).to eq([[:company]])

    end

    it '#has_many' do

      expect(subject.relationships_types.has_many).to eq([[:users]])

    end

    it '#has_one' do

      expect(subject.relationships_types.has_one).to eq([[:account]])

    end

    it '#has_and_belongs_to_many' do

      expect(subject.relationships_types.has_and_belongs_to_many).to eq([[:disclosure]])

    end

  end

  describe '#relationships' do

    it 'returns an array of relations' do

      expect(subject.relationships).to eq [:users, :account, :company, :disclosure]

    end

  end


  context 'inject string_reader as file_reader' do

    let(:example_model){
      StringReader.new(
          <<-eos
            class Person < ActiveRecord::Base

              belongs_to :zip_code

              def full_name(first_name, last_name)

              end

            end
          eos
      )
    }

    let(:subject){described_class.new({model_dir: File.expand_path('../../', __FILE__), file_reader: example_model})}

    let(:search){subject.parse('Person')}

    it 'let not read a file but return a string instead to be evaluated' do
      expect(search.relationships_types.belongs_to).to eq  [[:zip_code]]
      expect(subject.instance_methods).to eq([:full_name])
      expect(subject.instance_methods_with_arguments).to eq([{:full_name=>[[:req, :first_name], [:req, :last_name]]}])
    end

  end

  describe

end

