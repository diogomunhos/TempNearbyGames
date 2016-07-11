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

ActiveRecord::Schema.define(version: 20160711005519) do

  create_table "advertisings", force: :cascade do |t|
    t.boolean  "is_active"
    t.string   "advertising_type"
    t.integer  "position"
    t.string   "html_body"
    t.string   "tags"
    t.integer  "quantity"
    t.string   "pages"
    t.boolean  "is_default"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "article_documents", force: :cascade do |t|
    t.string   "document_type"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "article_id"
    t.integer  "document_id"
  end

  create_table "articles", force: :cascade do |t|
    t.string   "title"
    t.string   "body"
    t.string   "subtitle"
    t.string   "preview"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "article_type"
    t.boolean  "is_highlight"
    t.string   "tags"
    t.string   "friendly_url"
  end

  create_table "documents", force: :cascade do |t|
    t.string   "file_name"
    t.string   "content_type"
    t.binary   "file_contents"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "tags"
    t.decimal  "file_size"
  end

  create_table "profiles", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tags", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "last_name"
    t.string   "email"
    t.string   "nickname"
    t.integer  "profile_id"
    t.integer  "role_id"
    t.string   "password"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "password_confirmation"
  end

end
