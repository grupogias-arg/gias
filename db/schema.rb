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

ActiveRecord::Schema[8.1].define(version: 2026_10_06_153526) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.text "body"
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "campaigns", force: :cascade do |t|
    t.boolean "coords_estimated", default: false, null: false
    t.datetime "created_at", null: false
    t.date "date"
    t.integer "days"
    t.text "description"
    t.text "description_en"
    t.decimal "lat", precision: 9, scale: 6
    t.decimal "lng", precision: 9, scale: 6
    t.string "locality"
    t.string "name", null: false
    t.string "name_en"
    t.string "province"
    t.datetime "updated_at", null: false
    t.integer "year_end"
    t.integer "year_start"
    t.index ["date"], name: "index_campaigns_on_date"
    t.index ["year_start"], name: "index_campaigns_on_year_start"
  end

  create_table "members", force: :cascade do |t|
    t.text "bio"
    t.text "bio_en"
    t.string "conicet_url"
    t.datetime "created_at", null: false
    t.string "email"
    t.text "focus"
    t.text "focus_en"
    t.string "name", null: false
    t.integer "position", default: 0, null: false
    t.string "rank"
    t.string "rank_en"
    t.string "researchgate_url"
    t.string "sede"
    t.datetime "updated_at", null: false
    t.index ["position"], name: "index_members_on_position"
  end

  create_table "outreach_items", force: :cascade do |t|
    t.string "authors"
    t.datetime "created_at", null: false
    t.string "kind", default: "video", null: false
    t.integer "position", default: 0, null: false
    t.string "title", null: false
    t.string "title_en"
    t.datetime "updated_at", null: false
    t.string "url"
    t.string "youtube_id"
    t.index ["kind"], name: "index_outreach_items_on_kind"
    t.index ["position"], name: "index_outreach_items_on_position"
  end

  create_table "posts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "excerpt"
    t.text "excerpt_en"
    t.string "kind", default: "divulgacion", null: false
    t.datetime "published_at"
    t.string "slug", null: false
    t.string "title", null: false
    t.string "title_en"
    t.datetime "updated_at", null: false
    t.index ["kind"], name: "index_posts_on_kind"
    t.index ["published_at"], name: "index_posts_on_published_at"
    t.index ["slug"], name: "index_posts_on_slug", unique: true
  end

  create_table "projects", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.text "description_en"
    t.string "funder", default: "otros", null: false
    t.string "title", null: false
    t.string "title_en"
    t.datetime "updated_at", null: false
    t.integer "year_end"
    t.integer "year_start"
    t.index ["funder"], name: "index_projects_on_funder"
    t.index ["year_start"], name: "index_projects_on_year_start"
  end

  create_table "publications", force: :cascade do |t|
    t.string "authors"
    t.datetime "created_at", null: false
    t.string "doi"
    t.string "journal"
    t.string "kind", default: "cientifica", null: false
    t.string "title", null: false
    t.string "title_en"
    t.datetime "updated_at", null: false
    t.integer "year"
    t.index ["doi"], name: "index_publications_on_doi", unique: true
    t.index ["kind"], name: "index_publications_on_kind"
    t.index ["year"], name: "index_publications_on_year"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
end
