require 'rspec'
$:.unshift File.expand_path('../../', __FILE__)
require 'singleton'
require 'logger'
require 'active_mocker/logger'
require 'string_reader'
require 'active_mocker/public_methods'
require 'active_mocker/collection_association'
require 'active_mocker/table'
require 'active_mocker/config'
require 'active_mocker/reparameterize'
require 'active_mocker/field'
require 'active_mocker/active_record'
require 'active_mocker/model_reader'
require 'active_mocker/schema_reader'
require 'active_mocker/active_record/schema'
require 'active_mocker/base'
require 'active_support/all'
require 'active_hash/ar_api'

describe ActiveMocker::Base do

  before(:each) do
    ActiveMocker.configure do |config|
      # Required Options
      config.schema_file = 'file is being inject as string'
      config.model_dir   = 'file is being inject as string'
      # Dependency injection
      config.schema_file_reader = schema_file
      config.model_file_reader  = model_file
      # Additional Options
      config.schema_attributes   = true  #default
      config.model_attributes    = true  #default
      config.clear_cache         = true  #default
      config.migration_dir       = '/Users/zeisler/dev/active_mocker/spec/lib/active_mocker/performance/migration'
      # Logging
      config.log_level = Logger::WARN       #default
    end

  end

  let(:mock_class){
    ActiveMocker.mock('Person')
  }

    let(:model_file){
      StringReader.new <<-eos
        class Person < ActiveRecord::Base
        end
      eos
    }

    let(:schema_file){
      StringReader.new <<-eos
        ActiveRecord::Schema.define(version: 20140327205359) do

            create_table "people", force: true do |t|
              t.integer  "account_id"
              t.string   "first_name",        limit: 128
              t.string   "last_name",         limit: 128
              t.string   "address",         limit: 200
              t.string   "city",              limit: 100
              t.string   "800_number",              limit: 100
            end

          end
      eos
    }

  describe '::column_names' do

    it 'returns an array of column names found from the schema.rb file' do
      expect(mock_class.column_names).to eq(["id", "account_id", "first_name", "last_name", "address", "city", "800_number"])
    end

  end

  describe 'mass_assignment' do

    it "can pass any or all attributes from schema in initializer" do
      result = mock_class.new(first_name: "Sam", last_name: 'Walton')
      expect(result.first_name).to eq 'Sam'
      expect(result.last_name).to eq 'Walton'

    end

    it 'will raise error if not an attribute or association' do
      expect{mock_class.new(baz: "Hello")}.to raise_error('Rejected params: {"baz"=>"Hello"} for PersonMock')
    end

  end

  describe '#mock_class' do

    it 'create a mock object after the active record' do
      expect(mock_class).to eq(PersonMock)
    end

    context 'private methods' do

      let(:model_file){
        StringReader.new <<-eos
        class Person < ActiveRecord::Base
          private

          def bar
          end

        end
        eos
      }

      it 'will not have private methods' do
        expect{mock_class.bar}.to raise_error(NoMethodError)
      end

    end

    describe '#mock_of' do

      it 'return the name of the class that is being mocked' do
        expect(mock_class.new.mock_of).to eq 'Person'
      end

    end

    describe 'relationships' do

      let(:model_file){
        StringReader.new <<-eos
        class Person < ActiveRecord::Base
          belongs_to :account
          has_many :files
        end
        eos
      }

      it 'add instance methods from model relationships' do
        result = mock_class.new(account: 'Account')
        expect(result.account).to eq 'Account'
      end

      it 'add has_many relationship' do

        expect(mock_class.new.files.class).to eq ActiveMocker::CollectionAssociation
        expect(mock_class.new.files.count).to eq 0
        mock_inst = mock_class.new
        mock_inst.files << 1
        expect(mock_inst.files.count).to eq 1

      end

    end

    describe 'conflict of instance mocks and class mocks' do

      let(:model_file){
        StringReader.new <<-eos
        class Person < ActiveRecord::Base
          def bar(name, type=nil)
          end

          def self.bar
          end
        end
        eos
      }

      it 'can mock instance method and class method of the same name' do
        result = mock_class.new
        result.mock_instance_method(:bar) do  |name, type=nil|
          "Now implemented with #{name} and #{type}"
        end
        result = result.bar('foo', 'type')
        expect(result).to eq "Now implemented with foo and type"
        expect{mock_class.bar}.to raise_error('::bar is not Implemented for Class: PersonMock')

        mock_class.mock_class_method(:bar) do
          "Now implemented"
        end
        expect{mock_class.bar}.to_not raise_error
        expect(mock_class.bar).to eq("Now implemented")
      end

    end

    describe 'instance methods' do

      let(:model_file){
        StringReader.new <<-eos
        class Person < ActiveRecord::Base
          def bar(name, type=nil)
          end

          def baz
          end
        end
        eos
      }

      it 'will raise exception for unimplemented methods' do
        expect(mock_class.new.method(:bar).parameters).to eq  [[:req, :name], [:opt, :type]]
        expect{mock_class.new.bar}.to raise_error ArgumentError
        expect{mock_class.new.bar('foo', 'type')}.to raise_error('#bar is not Implemented for Class: PersonMock')
      end

      it 'can be implemented dynamically' do

        mock_class.mock_instance_method(:bar) do  |name, type=nil|
          "Now implemented with #{name} and #{type}"
        end

        result = mock_class.new
        result = result.bar('foo', 'type')
        expect(result).to eq "Now implemented with foo and type"

      end

      it 'can reference another mock' do

        mock_class.mock_instance_method(:bar) do  |name, type=nil|
          "Now implemented with #{name} and #{type}"
        end

        mock_class.mock_instance_method(:baz) do
          bar("name", 'type')
        end

        expect(mock_class.new.bar("name", 'type')).to eq "Now implemented with name and type"
        expect(mock_class.new.baz).to eq "Now implemented with name and type"
      end

      context 'can call real code by delegating to model' do

        let(:model_file){
          StringReader.new <<-eos
        class Person < ActiveRecord::Base
          def bar(name, type=nil)
            name + ' bar' + foo + ' ' +type
          end

          def foo
            'foo'
          end

          def baz
          end

          def self.foobar
            'foobar'
          end
        end
          eos
        }

        it 'can delegate instance method to models instance method' do

          mock_class.mock_instance_method(:bar) do  |name, type=nil|
            delegate_to_model_instance(:bar, name, type)
          end

          expect(mock_class.new.bar('name','type')).to eq  "name barfoo type"

        end

        it 'can delegate class method to models class method' do

          mock_class.mock_class_method(:foobar) do
            delegate_to_model_class(:foobar)
          end

          expect(mock_class.foobar).to eq  "foobar"

        end

      end

    end

    describe 'class methods' do

      let(:model_file){
        StringReader.new <<-eos
        class Person < ActiveRecord::Base
          scope :named, -> { }

          def self.class_method
          end
        end
        eos
      }

      it 'will raise exception for unimplemented methods' do
        expect{mock_class.class_method}.to raise_error('::class_method is not Implemented for Class: PersonMock')
      end

      it 'can be implemented as follows' do

        mock_class.mock_class_method(:class_method) do
          "Now implemented"
        end
        expect{mock_class.class_method}.to_not raise_error
        expect(mock_class.class_method).to eq("Now implemented")

      end

      it 'loads named scopes as class method' do
        expect{mock_class.named}.to raise_error('::named is not Implemented for Class: PersonMock')
      end

    end

  end

  context 'active_hash' do

      let(:model_file){
        StringReader.new <<-eos
        class Person < ActiveRecord::Base
          belongs_to :account

          def bar
          end

        end
        eos
      }

      it 'uses active_hash::base as superclass' do
        expect(mock_class.superclass.name).to eq 'ActiveHash::Base'
      end

      it 'can mass assign attributes to constructor' do
        result = mock_class.new(first_name: "Sam", last_name: 'Walton', account: 0)
        expect(result.first_name).to eq 'Sam'
        expect(result.last_name).to eq 'Walton'
        expect(result.account).to eq 0
      end

      it 'can save to class and then find instance by attribute' do

        record = mock_class.create(first_name: "Sam", last_name: 'Walton')
        expect(mock_class.find_by_first_name("Sam")).to eq record

      end

      it '::column_names' do
        expect(mock_class.column_names).to eq(["id", "account_id", "first_name", "last_name", "address", "city","800_number"])
      end

      it '#mock_of' do
        expect(mock_class.new.mock_of).to eq 'Person'
      end

      it 'instance methods from model' do
        expect{mock_class.new.bar}.to raise_error '#bar is not Implemented for Class: PersonMock'
      end

      let(:model_file){
        StringReader.new <<-eos
        class Person < ActiveRecord::Base
          belongs_to :account

          def bar
          end

        end
        eos
      }

      it '#update' do

        person = mock_class.create(first_name: 'Justin')

        expect(PersonMock.first.first_name).to eq 'Justin'
        person.update(first_name: 'Dustin')
        expect(PersonMock.first.first_name).to eq 'Dustin'

        expect(person.first_name).to eq 'Dustin'


      end

      it '::destroy_all' do

        mock_class.create

        expect(mock_class.count).to eq 1

        mock_class.destroy_all

        expect(mock_class.count).to eq 0

      end

      it '::find_by' do
        person = mock_class.create(first_name: 'dustin')
        expect(mock_class.find_by(first_name: 'dustin')).to eq person
      end

      it '::find_or_create_by' do
        person = mock_class.find_or_create_by(first_name: 'dustin')
        expect(mock_class.find_by(first_name: 'dustin')).to eq person
        person = mock_class.find_or_create_by(first_name: 'dustin')
        expect(mock_class.count).to eq 1
      end

      it '::find_or_create_by with update' do
        mock_class.create(first_name: 'dustin')
        person = mock_class.find_or_create_by(first_name: 'dustin')
        person.update(last_name: 'Zeisler')
        expect(mock_class.first.attributes).to eq person.attributes
        expect(mock_class.count).to eq 1
      end

      it '::find_or_initialize_by' do
        person = mock_class.find_or_initialize_by(first_name: 'dustin')
        expect(person.persisted?).to eq false
        mock_class.create(first_name: 'dustin')
        person = mock_class.find_or_initialize_by(first_name: 'dustin')
        expect(person.persisted?).to eq true
      end

      after(:each) do
        mock_class.delete_all
      end


  end

  describe '::configure' do

    it 'requires schema_file' do
      ActiveMocker::Base.reload_default
      expect{
        ActiveMocker::Base.configure {
        }
      }.to raise_error

    end


    it 'requires model_dir' do
      ActiveMocker::Base.reload_default
      expect{
        ActiveMocker::Base.configure { |c|
          c.schema_file = 'dir'
        }
      }.to raise_error

    end

  end

  describe 'cannot redefine attributes method' do

    let(:model_file){
      StringReader.new <<-eos
        class Person < ActiveRecord::Base
          def attributes; end

        end
      eos
    }

    it 'still works' do

      mock_class.new.attributes

    end


  end

end
