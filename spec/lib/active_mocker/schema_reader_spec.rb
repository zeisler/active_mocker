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
    StringReader.new(
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

    let(:subject){described_class.new({schema_file:nil, file_reader: example_schema})}

    let(:search){subject.search('people')}

    it 'let not read a file but return a string instead to be evaluated' do
      people = subject.search('people')
      expect(people.name).to eq 'people'
      expect(people.fields[2].to_h).to eq({:name=>"first_name", :type=>:string, :options=>[{:limit=>128}]})
      expect(subject.search('zip_codes').name).to eq 'zip_codes'
    end

  end

  context 'reads from file' do

    let(:subject){described_class.new({schema_file: schema_file})}


    describe '#search' do

      it 'takes a table name and will return its attributes' do
        described_class.new({schema_file: schema_file}).search("people")
      end

    end

    let(:people_search){subject.search("people")}

    describe '#column_names' do

      it 'returns an array of columns from the schema.rb' do
        expect(people_search.name).to eq 'people'
        expect(people_search.column_names).to eq ["id", "company_id", "first_name", "middle_name", "last_name", "address_1", "address_2", "city", "state_id", "zip_code_id", "title", "department", "person_email", "work_phone", "cell_phone", "home_phone", "fax", "user_id_assistant", "birth_date", "needs_review", "created_at", "updated_at"]
      end

    end

    describe '#fields' do

      it 'returns all fields from schema' do
        expect(people_search.fields[1].to_h).to eq({:name=>"company_id", :type=>:integer, :options=>[]})
      end

    end

    describe '#name' do

      it 'returns the name of the table' do
        expect(people_search.name).to eq("people")
      end


    end

    it 'returns an exception if table not found in schema.rb' do
      expect{
        described_class.new(
            {schema_file: schema_file}
        ).search("disclosures")
      }.to raise_error 'disclosures table not found.'
    end

  end

end