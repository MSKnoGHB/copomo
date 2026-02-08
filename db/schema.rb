# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2026_02_08_043638) do

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "chat_logs", force: :cascade do |t|
    t.integer "room_id", null: false
    t.integer "user_id", null: false
    t.integer "stamp_id"
    t.string "message"
    t.integer "message_type", null: false
    t.boolean "is_active", default: true, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["is_active"], name: "index_chat_logs_on_is_active"
    t.index ["message_type"], name: "index_chat_logs_on_message_type"
    t.index ["room_id"], name: "index_chat_logs_on_room_id"
    t.index ["stamp_id"], name: "index_chat_logs_on_stamp_id"
    t.index ["user_id"], name: "index_chat_logs_on_user_id"
  end

  create_table "comments", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "study_record_id", null: false
    t.string "comment_body", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["study_record_id"], name: "index_comments_on_study_record_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "follows", force: :cascade do |t|
    t.integer "followee_id", null: false
    t.integer "follower_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["followee_id"], name: "index_follows_on_followee_id"
    t.index ["follower_id", "followee_id"], name: "index_follows_on_follower_id_and_followee_id", unique: true
    t.index ["follower_id"], name: "index_follows_on_follower_id"
  end

  create_table "likes", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "study_record_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["study_record_id"], name: "index_likes_on_study_record_id"
    t.index ["user_id", "study_record_id"], name: "index_likes_on_user_id_and_study_record_id", unique: true
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "room_accesses", force: :cascade do |t|
    t.integer "room_id", null: false
    t.integer "user_id", null: false
    t.integer "study_theme_id"
    t.datetime "entry_time", null: false
    t.datetime "exit_time"
    t.boolean "is_active", default: true, null: false
    t.integer "exit_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["exit_type"], name: "index_room_accesses_on_exit_type"
    t.index ["is_active"], name: "index_room_accesses_on_is_active"
    t.index ["room_id"], name: "index_room_accesses_on_room_id"
    t.index ["study_theme_id"], name: "index_room_accesses_on_study_theme_id"
    t.index ["user_id"], name: "index_room_accesses_on_user_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.integer "focus_minutes", null: false
    t.integer "break_minutes", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name", null: false
  end

  create_table "stamps", force: :cascade do |t|
    t.string "stamp_name", null: false
    t.boolean "is_active", default: true, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["is_active"], name: "index_stamps_on_is_active"
  end

  create_table "study_categories", force: :cascade do |t|
    t.string "category_title", null: false
    t.text "category_body"
    t.boolean "is_active", default: true, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["category_title"], name: "index_study_categories_on_category_title"
    t.index ["is_active"], name: "index_study_categories_on_is_active"
  end

  create_table "study_intervals", force: :cascade do |t|
    t.integer "study_records_id", null: false
    t.datetime "started_at", null: false
    t.datetime "ended_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["study_records_id"], name: "index_study_intervals_on_study_records_id"
  end

  create_table "study_records", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "study_room_id", null: false
    t.integer "study_theme_id", null: false
    t.datetime "started_at", null: false
    t.datetime "ended_at"
    t.integer "total_focus_minutes"
    t.integer "study_status", default: 0, null: false
    t.text "record_body"
    t.boolean "is_publish", default: true, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["is_publish"], name: "index_study_records_on_is_publish"
    t.index ["study_room_id"], name: "index_study_records_on_study_room_id"
    t.index ["study_status"], name: "index_study_records_on_study_status"
    t.index ["study_theme_id"], name: "index_study_records_on_study_theme_id"
    t.index ["user_id"], name: "index_study_records_on_user_id"
  end

  create_table "study_themes", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "study_category_id", null: false
    t.string "theme_title", null: false
    t.text "theme_body"
    t.string "theme_color", null: false
    t.boolean "is_active", default: true, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["is_active"], name: "index_study_themes_on_is_active"
    t.index ["study_category_id"], name: "index_study_themes_on_study_category_id"
    t.index ["user_id"], name: "index_study_themes_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name", null: false
    t.boolean "is_active", default: true, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["is_active"], name: "index_users_on_is_active"
    t.index ["name"], name: "index_users_on_name", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "chat_logs", "rooms"
  add_foreign_key "chat_logs", "stamps"
  add_foreign_key "chat_logs", "users"
  add_foreign_key "comments", "study_records"
  add_foreign_key "comments", "users"
  add_foreign_key "follows", "users", column: "followee_id"
  add_foreign_key "follows", "users", column: "follower_id"
  add_foreign_key "likes", "study_records"
  add_foreign_key "likes", "users"
  add_foreign_key "room_accesses", "rooms"
  add_foreign_key "room_accesses", "study_themes"
  add_foreign_key "room_accesses", "users"
  add_foreign_key "study_intervals", "study_records", column: "study_records_id"
  add_foreign_key "study_records", "study_rooms"
  add_foreign_key "study_records", "study_themes"
  add_foreign_key "study_records", "users"
  add_foreign_key "study_themes", "study_categories"
  add_foreign_key "study_themes", "users"
end
