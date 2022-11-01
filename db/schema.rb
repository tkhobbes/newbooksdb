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

ActiveRecord::Schema[7.0].define(version: 2022_11_01_154753) do
  create_table "action_text_rich_texts", charset: "utf8mb4", force: :cascade do |t|
    t.string "name", null: false
    t.text "body", size: :long
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", charset: "utf8mb4", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8mb4", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "authors", charset: "utf8mb4", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "sort_name"
    t.string "display_name"
    t.integer "born"
    t.integer "died"
    t.string "gender"
    t.integer "rating", default: 0
    t.string "slug"
    t.integer "books_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["first_name", "last_name"], name: "index_authors_on_first_name_and_last_name", unique: true
    t.index ["slug"], name: "index_authors_on_slug", unique: true
  end

  create_table "book_formats", charset: "utf8mb4", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "fallback", default: false
    t.integer "books_count"
    t.index ["name"], name: "index_book_formats_on_name", unique: true
  end

  create_table "books", charset: "utf8mb4", force: :cascade do |t|
    t.string "title", null: false
    t.string "sort_title"
    t.integer "year"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "rating", default: 0
    t.integer "condition", default: 0
    t.string "edition"
    t.string "slug"
    t.bigint "book_format_id", null: false
    t.string "original_title"
    t.bigint "user_id", null: false
    t.integer "shelf_id"
    t.integer "publisher_id"
    t.string "country"
    t.integer "author_id"
    t.bigint "owner_id", null: false
    t.index ["book_format_id"], name: "index_books_on_book_format_id"
    t.index ["owner_id"], name: "index_books_on_owner_id"
    t.index ["slug"], name: "index_books_on_slug", unique: true
    t.index ["title", "owner_id"], name: "index_books_on_title_and_owner_id", unique: true
    t.index ["title", "user_id"], name: "index_books_on_title_and_user_id", unique: true
    t.index ["user_id"], name: "index_books_on_user_id"
  end

  create_table "books_authors", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "book_id", null: false
    t.bigint "author_id", null: false
    t.index ["author_id"], name: "index_books_authors_on_author_id"
    t.index ["book_id", "author_id"], name: "index_books_authors_on_book_id_and_author_id", unique: true
    t.index ["book_id"], name: "index_books_authors_on_book_id"
  end

  create_table "books_genres", id: false, charset: "utf8mb4", force: :cascade do |t|
    t.bigint "genre_id", null: false
    t.bigint "book_id", null: false
  end

  create_table "genres", charset: "utf8mb4", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.index ["name"], name: "index_genres_on_name", unique: true
    t.index ["slug"], name: "index_genres_on_slug", unique: true
  end

  create_table "owners", charset: "utf8mb4", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_owners_on_email", unique: true
    t.index ["reset_password_token"], name: "index_owners_on_reset_password_token", unique: true
  end

  create_table "profiles", charset: "utf8mb4", force: :cascade do |t|
    t.string "name"
    t.bigint "owner_id", null: false
    t.boolean "admin", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_id"], name: "index_profiles_on_owner_id"
  end

  create_table "publishers", charset: "utf8mb4", force: :cascade do |t|
    t.string "name", null: false
    t.string "location"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "books_count"
    t.index ["name"], name: "index_publishers_on_name", unique: true
    t.index ["slug"], name: "index_publishers_on_slug", unique: true
  end

  create_table "shelves", charset: "utf8mb4", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "books_count"
    t.index ["name", "user_id"], name: "index_shelves_on_name_and_user_id", unique: true
    t.index ["user_id"], name: "index_shelves_on_user_id"
  end

  create_table "taggings", charset: "utf8mb4", force: :cascade do |t|
    t.integer "tag_id", null: false
    t.string "taggable_type"
    t.integer "taggable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
  end

  create_table "tags", charset: "utf8mb4", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.index ["name", "user_id"], name: "index_tags_on_name_and_user_id", unique: true
    t.index ["slug"], name: "index_tags_on_slug", unique: true
    t.index ["user_id"], name: "index_tags_on_user_id"
  end

  create_table "users", charset: "utf8mb4", force: :cascade do |t|
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "remember_digest"
    t.string "activation_digest"
    t.boolean "activated", default: false
    t.datetime "activated_at"
    t.string "reset_digest"
    t.datetime "reset_sent_at"
    t.integer "books_count"
    t.boolean "admin"
    t.string "name"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "books", "book_formats"
  add_foreign_key "books", "owners"
  add_foreign_key "books_authors", "authors"
  add_foreign_key "books_authors", "books"
  add_foreign_key "profiles", "owners"
  add_foreign_key "shelves", "users"
  add_foreign_key "tags", "users"
end
