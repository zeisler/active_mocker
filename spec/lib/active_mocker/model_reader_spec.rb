require 'spec_helper'
require 'active_support/core_ext/hash/indifferent_access'
require 'singleton'
require 'logger'
require 'lib/active_mocker/logger'
require 'lib/active_mocker/string_reader'
require 'lib/active_mocker/file_reader'
require 'lib/active_mocker/logger'
require 'lib/active_mocker/active_record'
require 'lib/active_mocker/model_reader'
require 'lib/active_mocker/reparameterize'
require 'parser/current'
require 'unparser'
require 'lib/active_mocker/ruby_parse'
require 'lib/active_mocker/config'
require 'lib/active_mocker/generate'
require_relative '../../unit_logger'

describe ActiveMocker::ModelReader do

  before(:each) do
    ActiveMocker::Config.reset_all
    ActiveMocker::Config.load_defaults
    ActiveMocker::Config.model_dir = File.expand_path('../../', __FILE__)
  end

  let(:model_reader){ described_class.new.parse('model') }

  let(:subject){ model_reader}

  describe '#parse' do

    let(:subject){ described_class.new }

    it 'takes a model name to the active_record model class' do
      subject.parse('model')
    end

  end

  describe '#class_methods' do

    it 'returns all public class methods' do
      expect(subject.class_methods).to eq([:duper, :foo, :bang!])
    end

  end

  describe '#modules' do

    it 'returns all public class methods' do
      expect(subject.modules).to eq({:included => %w[FooBar ModelCore::PlanService::Dah], :extended => ['Baz']})
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
      expect(subject.class_methods_with_arguments).to eq([{:duper => [[:req, :value], [:rest, :args]]}, {:foo => []}, {:bang! =>[]}])
    end

  end

  describe '#scopes_with_arguments' do

    it 'returns all scoped methods' do
      result = subject.scopes_with_arguments
      result.first[:proc] = nil
      expect(result.first).to eq({:named => [[:req, :name], [:opt, :value], [:opt, :options]], :proc => nil})
    end

  end

  context 'inject string_reader as file_reader' do

    let(:example_model){
      ActiveMocker::StringReader.new(
          <<-eos
            class Person < ActiveRecord::Base

              belongs_to :zip_code

              def full_name(first_name, last_name)

              end

            end
          eos
      )
    }

    before(:each) do
      ActiveMocker::Config.file_reader = example_model
    end

    let(:subject){described_class.new}

    let(:search){subject.parse('person')}

    it 'will evaluate string instead of opening file' do
      expect(search.instance_methods).to eq([:full_name])
      expect(search.instance_methods_with_arguments).to eq([{:full_name=>[[:req, :first_name], [:req, :last_name]]}])
    end

  end

  describe 'if Parent class contains ActiveRecord it will be treated at the base' do

    context 'no STI' do

      let(:example_model) {
        ActiveMocker::StringReader.new(
            <<-eos
            class Identity < OmniAuth::Identity::Models::ActiveRecord

              def id
              end


            end
        eos
        )
      }

      before(:each) do
        ActiveMocker::Config.file_reader = example_model
      end

      let(:subject) { described_class.new }

      let(:search) { subject.parse('identity') }

      it 'it gets the method' do
        ActiveMocker::Config.model_base_classes = %w[ActiveRecord::Base OmniAuth::Identity::Models::ActiveRecord]
        expect(search.instance_methods).to eq([:id])
      end

    end

   context 'with STI' do

     let(:example_model) {
       module ActiveMocker
         # @api private
         class StringReader2

           attr_accessor :reader

           def initialize(child)
             @reader = {child: child}
           end

           def read(path)
             @reader[Pathname.new(path).basename.sub('.rb', '').to_s.to_sym]
           end
         end

       end


       reader = ActiveMocker::StringReader2.new(<<-eos
            class Child < Parent

              def child_method

              end

              scope :scoped_method2, -> {}

            end
       eos
       )

       reader.reader[:parent] = <<-eos
            class Parent < ActiveRecord::Base

              scope :scoped_method, -> {}

              def full_name(first_name, last_name)

              end

            end
       eos
       reader
     }

     before(:each) do
       ActiveMocker::Config.file_reader = example_model
     end

     let(:subject) { described_class.new }

     let(:child) { subject.parse('child') }
     let(:parent) { subject.parse('parent') }

     it 'it will only include properties from its self' do
       expect(child.instance_methods).to eq([:child_method])
       expect(child.scopes.keys).to eq([:scoped_method2])
     end

     it 'parent will have its own properties' do
       expect(parent.instance_methods).to eq([:full_name])
       expect(parent.scopes.keys).to eq([:scoped_method])
     end

   end

  end

  context 'parent child' do

    let(:example_model) {
      module ActiveMocker
        # @api private
        class StringReader2

          attr_accessor :reader
          def initialize(child)
            @reader = {child: child}
          end

          def read(path)
            @reader[Pathname.new(path).basename.sub('.rb', '').to_s.to_sym]
          end
        end

      end


      reader = ActiveMocker::StringReader2.new(<<-eos
            class Child < Parent

              def child_method

              end

              scope :scoped_method, -> {}

            end
      eos
      )

      reader.reader[:parent] = <<-eos
            class Parent < ActiveRecord::Base

              belongs_to :zip_code

              def full_name(first_name, last_name)

              end

            end
      eos
      reader
    }

    before(:each) do
      ActiveMocker::Config.file_reader = example_model
    end

    let(:subject) { described_class.new}

    let(:child) { subject.parse('child') }
    let(:parent) { subject.parse('parent') }

    it 'child only self properties' do
      expect(child.instance_methods).to eq([:child_method])
      expect(child.scopes.keys).to eq([:scoped_method])
    end

    it 'parent has all self properties' do
      expect(parent.instance_methods).to eq([:full_name])
      expect(parent.scopes.keys).to eq([])
    end

  end

end