require 'rspec'
$:.unshift File.expand_path('../../', __FILE__)

require 'active_mocker/active_record/schema'
require 'active_mocker/model_reader'

describe ActiveMocker::ActiveRecord::Schema do


  it '' do

    result = described_class.define(version: 1) do

      create_table "advisor_fee_groups", force: true do |t|
        t.integer "service_fee_id_legacy"
        t.integer "plan_id",                      limit: 8
        t.string  "name",                         limit: 64
        t.string  "description",                  limit: 256
        t.boolean "effective_immediately"
        t.boolean "delayed_effective_date"
        t.date    "effective_date"
        t.integer "plan_tiered_fees_template_id"
      end

      create_table "advisor_fee_groups", force: true do |t|
        t.integer "service_fee_id_legacy"
        t.integer "plan_id",                      limit: 8
        t.string  "name",                         limit: 64
        t.string  "description",                  limit: 256
        t.boolean "effective_immediately"
        t.boolean "delayed_effective_date"
        t.date    "effective_date"
        t.integer "plan_tiered_fees_template_id"
      end

      add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree

    end

    expect(result).to eq({:tables=>[{:table_name=>"advisor_fee_groups", :fields=>[{:name=>"service_fee_id_legacy", :type=>:integer, :options=>[]}, {:name=>"plan_id", :type=>:integer, :options=>[{:limit=>8}]}, {:name=>"name", :type=>:string, :options=>[{:limit=>64}]}, {:name=>"description", :type=>:string, :options=>[{:limit=>256}]}, {:name=>"effective_immediately", :type=>:boolean, :options=>[]}, {:name=>"delayed_effective_date", :type=>:boolean, :options=>[]}, {:name=>"effective_date", :type=>:date, :options=>[]}, {:name=>"plan_tiered_fees_template_id", :type=>:integer, :options=>[]}]}, {:table_name=>"advisor_fee_groups", :fields=>[{:name=>"service_fee_id_legacy", :type=>:integer, :options=>[]}, {:name=>"plan_id", :type=>:integer, :options=>[{:limit=>8}]}, {:name=>"name", :type=>:string, :options=>[{:limit=>64}]}, {:name=>"description", :type=>:string, :options=>[{:limit=>256}]}, {:name=>"effective_immediately", :type=>:boolean, :options=>[]}, {:name=>"delayed_effective_date", :type=>:boolean, :options=>[]}, {:name=>"effective_date", :type=>:date, :options=>[]}, {:name=>"plan_tiered_fees_template_id", :type=>:integer, :options=>[]}]}]})
  end



end