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
    ActiveMocker::Config.clear_settings
    ActiveMocker::Logger.set(UnitLogger)
    ActiveMocker::Config.model_base_classes = %w[ActiveRecord::Base]
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
      expect(subject.modules).to eq({:included => ["FooBar", "ModelCore::PlanService::Dah"], :extended => ["Baz"]})
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

  describe '#belongs_to' do

    let(:subject){model_reader.belongs_to}

    it 'name of association' do
      expect(subject.first.name).to eq(:company)
    end

    it 'class_name override' do
      expect(subject.first.class_name).to eq('PlanServiceCategory')
    end

    it 'infer class_name' do
      expect(subject.last.class_name).to eq('Person')
    end

    it 'infer foreign key' do
      expect(subject.last.foreign_key).to eq('person_id')
    end

    it 'foreign key override' do
      expect(subject.first.foreign_key).to eq('category_id')
    end

    it 'through' do
      expect(subject.last.through).to eq('customer')
    end

  end

  describe '#has_one' do

    let(:subject) { model_reader.has_one }

    it 'name of association' do
      expect(subject.first.name).to eq(:account)
    end

  end

  describe '#has_many' do

    let(:subject) { model_reader.has_many }

    it 'name of association' do
      expect(subject.first.name).to eq(:users)
    end

  end

  describe '#has_and_belongs_to_many' do

    let(:subject) { model_reader.has_and_belongs_to_many }

    it 'name of association' do
      expect(subject.first.name).to eq(:disclosures)
    end

  end

# TODO JoinTable
#     class Assembly < ActiveRecord::Base
#       has_and_belongs_to_many :parts
#     end
#
#     class Part < ActiveRecord::Base
#       has_and_belongs_to_many :assemblies
#     end
#     These need to be backed up by a migration to create the assemblies_parts table.This table should be created without a primary key:

#     class CreateAssembliesPartsJoinTable < ActiveRecord::Migration
#       def change
#         create_table :assemblies_parts, id: false do |t|
#           t.integer :assembly_id
#           t.integer :part_id
#         end
#       end
#     end

#   TODO Polymorphic Associations
#   A slightly more advanced twist on associations is the polymorphic association.With polymorphic associations, a model can belong to more than one other model, on a single association.For example, you might have a picture model that belongs to either an employee model or a product model.Here 's how this could be declared:
#
#     class Picture < ActiveRecord::Base
#       belongs_to :imageable, polymorphic: true
#     end
#
#     class Employee < ActiveRecord::Base
#       has_many :pictures, as: :imageable
#     end
#
#     class Product < ActiveRecord::Base
#       has_many :pictures, as: :imageable
#     end

#     class CreatePictures < ActiveRecord::Migration
#       def change
#         create_table :pictures do |t|
#           t.string :name
#           t.integer :imageable_id
#           t.string :imageable_type
#           t.timestamps
#         end
#       end
#     end



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

    it 'let not read a file but return a string instead to be evaluated' do
      expect(search.belongs_to.first.name).to eq :zip_code
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

     let(:subject) { described_class.new }

     let(:child) { subject.parse('child') }
     let(:parent) { subject.parse('parent') }

     it 'let not read a file but return a string instead to be evaluated' do
       expect(child.instance_methods).to eq([:child_method, :full_name])
       expect(child.scopes.keys).to eq([:scoped_method])
     end

     it 'let not read a file but return a string instead to be evaluated' do
       expect(parent.instance_methods).to eq([:full_name])
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

    it 'child has parent and self properties' do
      expect(child.instance_methods).to eq([:child_method, :full_name])
      expect(child.scopes.keys).to eq([:scoped_method])
      expect(child.belongs_to.map(&:name)).to eq([:zip_code])
    end

    it 'parent has all self properties' do
      expect(parent.instance_methods).to eq([:full_name])
      expect(parent.scopes.keys).to eq([])
      expect(parent.belongs_to.map(&:name)).to eq([:zip_code])
    end

  end

end

