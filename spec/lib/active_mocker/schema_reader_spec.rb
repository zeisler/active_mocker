require 'rspec'
$:.unshift File.expand_path('../../', __FILE__)
require 'string_reader'
require 'file_reader'
require 'active_mocker/table'
require 'active_mocker/field'
require 'active_mocker/active_record/schema'
require 'active_mocker/schema_reader'
require 'active_support/all'

describe ActiveMocker::SchemaReader do

  let(:schema_file){ File.join(File.expand_path('../../', __FILE__), 'schema.rb') }

  let(:example_schema){
    ActiveMocker::StringReader.new(
        <<-eos
            ActiveRecord::Schema.define(version: 20140327205359) do

              create_table "people", force: true do |t|
                t.integer  "company_id"
                t.string   "first_name",        limit: 128
                t.string   "middle_name",       limit: 128
                t.string   "last_name",         limit: 128
                t.string   "address_1",         limit: 200
                t.string   "address_2",         limit: 100
                t.string   "city",              limit: 100
                t.integer  "state_id"
                t.integer  "zip_code_id"
                t.string   "title",             limit: 150
                t.string   "department",        limit: 150
                t.string   "person_email",      limit: 150
                t.string   "work_phone",        limit: 20
                t.string   "cell_phone",        limit: 20
                t.string   "home_phone",        limit: 20
                t.string   "fax",               limit: 20

              end

              create_table "zip_codes", force: true do |t|
                t.string  "zip_code",       limit: 9
                t.integer "state_id"
                t.integer "cola_by_fip_id"
                t.string  "city_name",      limit: 100
                t.string  "County_name",    limit: 100
                t.decimal "City_Latitude",              precision: 8, scale: 4
                t.decimal "City_Longitude",             precision: 8, scale: 4
              end

              add_index "zip_codes", ["zip_code"], name: "index_zip_codes_on_zip_code", unique: true, using: :btree

            end

    eos
    )
  }

  context 'inject string_reader as file_reader' do

    let(:subject){described_class.new({schema_file:nil, file_reader: example_schema, clear_cache: true})}

    let!(:search){subject.search(nil)}

    it 'let not read a file but return a string instead to be evaluated' do
      tables = subject.tables
      expect(tables.first.name).to eq 'people'
      expect(tables.last.name).to eq 'zip_codes'
      expect(tables.last.fields.count).to eq 8
    end

  end

  context 'reads from file' do

    let(:subject){described_class.new({schema_file: schema_file})}


    describe '#search' do

      it 'takes a table name and will return its attributes' do
        described_class.new({schema_file: schema_file}).search(nil)
      end

    end

    let(:tables){subject.search("people")}

    describe '#column_names' do

      it 'returns an array of columns from the schema.rb' do
        tables
        expect(subject.tables.first.name).to eq 'people'
        expect(subject.tables.first.column_names).to eq ["id", "company_id", "first_name", "middle_name", "last_name", "address_1", "address_2", "city", "state_id", "zip_code_id", "title", "department", "person_email", "work_phone", "cell_phone", "home_phone", "fax", "user_id_assistant", "birth_date", "needs_review", "created_at", "updated_at"]
      end

    end

    describe '#fields' do

      it 'returns all fields from schema' do
        tables
        expect(subject.tables.first.fields[1].to_h).to eq({:name=>"company_id", :type=>:integer, :options=>{}})
      end

    end

  end

end