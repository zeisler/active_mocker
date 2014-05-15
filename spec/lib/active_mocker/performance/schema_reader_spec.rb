require 'rspec'
$:.unshift File.expand_path('../../', __FILE__)
require 'string_reader'
require 'file_reader'
require 'active_mocker/table'
require 'active_mocker/field'
require 'active_mocker/active_record/schema'
require 'active_mocker/schema_reader'
require 'active_support/all'

describe ActiveMocker::SchemaReader, pending: true do

  let(:schema_file){ File.join(File.expand_path('../../', __FILE__), 'performance/large_schema.rb') }

  context 'reads from file' do

    let(:subject){described_class.new({schema_file: schema_file, clear_cache: true})}

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

    describe 'plans table' do

      before(:all) do
        # described_class.new({clear_cache: true})
      end

      after(:all) do
        # described_class.new({clear_cache: true})
      end

      let(:subject){described_class.new({schema_file: schema_file, clear_cache: false})}

      it 'find table' do

        10.times do
          # 0.019135
          # 8.0e-06
          # 3.0e-06
          # 6.3e-05
          # 3.0e-06
          # 2.0e-06
          # 3.0e-06
          # 3.0e-06
          # 2.0e-06
          # 2.0e-06
          start = Time.now
          subject.search("plans").name
          # subject.search("disclosures").name
          # subject.search("bmg_tpa_masters").name
          # subject.search("bmg_rk_masters").name
          puts Time.now - start
        end

      end

    end

  end



end