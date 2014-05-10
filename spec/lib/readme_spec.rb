require 'rspec'
$:.unshift File.expand_path('../../../active_mocker', __FILE__)
require 'active_mocker'
require 'string_reader'

describe 'ReadMe' do

  before(:each) do
    ActiveMocker.configure do |config|
      # Required Options
      config.schema_file = ""
      config.model_dir   = ""
      config.schema_file_reader = schema_file
      config.model_file_reader  = model_file
      # Additional Options
      config.schema_attributes   = true  #default
      config.model_attributes    = true  #default
      config.clear_cache         = true
      # Logging
      config.log_level = Logger::WARN       #default
      config.migration_dir       = '/Users/zeisler/dev/active_mocker/spec/lib/active_mocker/performance/migration'

    end
  end

  let(:schema_file){
    StringReader.new <<-eos

      ActiveRecord::Schema.define(version: 20140327205359) do

        create_table "people", force: true do |t|
          t.integer  "account_id"
          t.string   "first_name",        limit: 128
          t.string   "last_name",         limit: 128
          t.string   "address",           limit: 200
          t.string   "city",              limit: 100
        end

      end

    eos
  }

  let(:model_file){
    StringReader.new <<-eos
      class Person < ActiveRecord::Base
        belongs_to :account

        def bar(name, type=nil)
          puts name
        end

        def self.bar
        end

      end
    eos
  }

  before do
    ActiveMocker.mock('Person')
  end

  let(:person_mock){PersonMock}

  describe 'Usage' do

    it 'Mock a Person' do
      expect(ActiveMocker.mock('Person')).to eq PersonMock
    end

    it '::column_names' do
      expect(PersonMock.column_names).to eq ["id", "account_id", "first_name", "last_name", "address", "city"]
    end

    it '::new' do
      expect(PersonMock.new(first_name: "Dustin", last_name: "Zeisler").inspect).to eq("#<PersonMock id: nil, account_id: nil, first_name: \"Dustin\", last_name: \"Zeisler\", address: nil, city: nil>")
    end

    it '#first_name' do
      person_mock = PersonMock.new(first_name: "Dustin", last_name: "Zeisler")
      expect( person_mock.first_name).to eq 'Dustin'
    end

  end

  describe 'When schema.rb changes, the mock fails' do

    let(:schema_file){
      StringReader.new <<-eos

      ActiveRecord::Schema.define(version: 20140327205359) do

        create_table "people", force: true do |t|
          t.integer  "account_id"
          t.string   "f_name",        limit: 128
          t.string   "l_name",        limit: 128
          t.string   "address",           limit: 200
          t.string   "city",              limit: 100
        end

      end

      eos
    }

    it 'fails' do
      expect{ActiveMocker.mock('Person').new(first_name: "Dustin", last_name: "Zeisler")}.to raise_error(RuntimeError)
    end

  end

  describe 'Mocking instance and class methods' do

    it 'bar is not Implemented' do
      expect{person_mock.bar}.to raise_error( RuntimeError, '::bar is not Implemented for Class: PersonMock' )
    end

    it 'is implemented' do
      person_mock.mock_instance_method(:bar) do  |name, type=nil|
        "Now implemented with #{name} and #{type}"
      end

      expect(person_mock.new.bar('foo', 'type')).to eq "Now implemented with foo and type"

      person_mock.mock_class_method(:bar) do
        "Now implemented"
      end

      expect(person_mock.bar).to eq "Now implemented"

    end

    it 'has argument error' do

      person_mock.mock_instance_method(:bar) do |name, type=nil|
        "Now implemented with #{name} and #{type}"
      end

      expect{person_mock.new.bar}.to raise_error(ArgumentError, 'wrong number of arguments (0 for 1..2)')

    end

  end

  describe 'When the model changes, the mock fails' do

    context 'different arguments' do

      let(:model_file){
        StringReader.new <<-eos
        class Person < ActiveRecord::Base
          belongs_to :account

          def bar(name)
            puts name
          end

        end
      eos
      }

      it 'has argument error' do

        person_mock.mock_instance_method(:bar) do |name, type=nil|
          "Now implemented with #{name} and #{type}"
        end

        expect{person_mock.new.bar('foo', 'type')}.to raise_error(ArgumentError, 'wrong number of arguments (2 for 1)')

      end

    end

    context 'different method name' do

      let(:model_file){
          StringReader.new <<-eos
        class Person < ActiveRecord::Base
          belongs_to :account

          def foo(name)
            puts name
          end

        end

      eos
      }

      it 'when method name changes' do

        person_mock.mock_instance_method(:bar) do  |name, type=nil|
          "Now implemented with #{name} and #{type}"
        end

        expect{person_mock.new.bar}.to raise_error(NoMethodError)

      end

    end

  end

end