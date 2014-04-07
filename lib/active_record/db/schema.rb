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
    t.integer  "user_id_assistant"
    t.date     "birth_date"
    t.boolean  "needs_review"
    t.datetime "created_at"
    t.datetime "updated_at"

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

end
