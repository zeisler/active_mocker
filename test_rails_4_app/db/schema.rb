# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160621215939) do

  create_table "accounts", force: :cascade do |t|
    t.integer "user_id"
    t.decimal "balance"
  end

  create_table "cusomters", force: :cascade do |t|
    t.string   "name"
    t.string   "email",                                    default: ""
    t.decimal  "credits",         precision: 19, scale: 6
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.boolean  "remember_token",                           default: true
    t.boolean  "admin",                                    default: false
  end

  create_table "customer", force: :cascade do |t|
    t.string   "name"
    t.string   "email",                                    default: ""
    t.decimal  "credits",         precision: 19, scale: 6
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.boolean  "remember_token",                           default: true
    t.boolean  "admin",                                    default: false
  end

  create_table "customers", force: :cascade do |t|
    t.string   "name"
    t.string   "email",                                    default: ""
    t.decimal  "credits",         precision: 19, scale: 6
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.boolean  "remember_token",                           default: true
    t.boolean  "admin",                                    default: false
  end

  create_table "identities", force: :cascade do |t|
    t.string   "name"
    t.string   "email",                                    default: ""
    t.decimal  "credits",         precision: 19, scale: 6
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.boolean  "remember_token",                           default: true
    t.boolean  "admin",                                    default: false
  end

  create_table "microposts", force: :cascade do |t|
    t.string   "content"
    t.integer  "user_id"
    t.integer  "up_votes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["user_id", "created_at"], name: "index_microposts_on_user_id_and_created_at"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
  end

  create_table "relationships", force: :cascade do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["followed_id"], name: "index_relationships_on_followed_id"
    t.index ["follower_id", "followed_id"], name: "index_relationships_on_follower_id_and_followed_id", unique: true
    t.index ["follower_id"], name: "index_relationships_on_follower_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email",                                    default: ""
    t.decimal  "credits",         precision: 19, scale: 6
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.boolean  "remember_token",                           default: true
    t.boolean  "admin",                                    default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["remember_token"], name: "index_users_on_remember_token"
  end

end
