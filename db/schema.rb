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

ActiveRecord::Schema.define(version: 20161104173243) do

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
    t.integer  "article_id"
    t.integer  "document_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "articles", force: :cascade do |t|
    t.string   "title"
    t.string   "body"
    t.string   "subtitle"
    t.string   "preview"
    t.string   "article_type"
    t.boolean  "is_highlight"
    t.string   "tags"
    t.string   "friendly_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by_id"
    t.string   "last_updated_by_id"
    t.string   "created_by_name"
    t.string   "last_updated_by_name"
    t.string   "status"
    t.string   "platform"
    t.string   "review_note"
    t.date     "release_date"
    t.integer  "views"
    t.string   "facebook_post_id"
    t.integer  "game_id"
  end

  create_table "companies", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "documents", force: :cascade do |t|
    t.string   "file_name"
    t.string   "content_type"
    t.binary   "file_contents"
    t.string   "tags"
    t.decimal  "file_size"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "field_permissions", force: :cascade do |t|
    t.string   "field_name"
    t.boolean  "read_record"
    t.boolean  "edit_record"
    t.integer  "object_permission_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "last_updated_by"
  end

  create_table "game_companies", force: :cascade do |t|
    t.integer  "game_id"
    t.integer  "company_id"
    t.string   "company_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "games", force: :cascade do |t|
    t.string   "name"
    t.date     "release_date"
    t.string   "platform"
    t.integer  "wahiga_rating"
    t.integer  "user_rating"
    t.string   "description"
    t.string   "genre"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "document_id"
  end

  create_table "historics", force: :cascade do |t|
    t.string   "entity"
    t.string   "changed_fields"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "object_id"
  end

  create_table "login_histories", force: :cascade do |t|
    t.string   "device"
    t.boolean  "is_success"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "object_permissions", force: :cascade do |t|
    t.string   "object_name"
    t.boolean  "read_record"
    t.boolean  "create_record"
    t.boolean  "edit_record"
    t.boolean  "delete_record"
    t.boolean  "read_all_record"
    t.boolean  "approve_record"
    t.integer  "profile_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "last_updated_by"
  end

  create_table "profiles", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active"
    t.integer  "created_by"
    t.integer  "last_updated_by"
  end

  create_table "social_identities", force: :cascade do |t|
    t.string   "uid"
    t.string   "provider"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_url"
  end

  create_table "tags", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_documents", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "document_id"
    t.string   "document_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_login_infos", force: :cascade do |t|
    t.boolean  "is_locked"
    t.string   "reset_password_token"
    t.date     "reset_request_date"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_preferences", force: :cascade do |t|
    t.boolean  "email_content"
    t.datetime "accepted_terms_date"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "facebook"
    t.string   "twitter"
    t.string   "instagram"
    t.string   "about"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "last_name"
    t.string   "email"
    t.string   "nickname"
    t.integer  "profile_id"
    t.integer  "role_id"
    t.string   "password"
    t.string   "password_confirmation"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "birthdate"
    t.boolean  "email_confirmed",       default: false
    t.string   "confirm_token"
  end

end
