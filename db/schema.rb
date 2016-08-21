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

ActiveRecord::Schema.define(version: 20160821152224) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "datasets", force: :cascade do |t|
    t.string   "name"
    t.string   "internal_name"
    t.integer  "source_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["source_id"], name: "index_datasets_on_source_id", using: :btree
  end

  create_table "external_tables", force: :cascade do |t|
    t.string   "external_id"
    t.string   "external_name"
    t.integer  "dataset_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.boolean  "active",        default: true
    t.index ["dataset_id"], name: "index_external_tables_on_dataset_id", using: :btree
  end

  create_table "frequencies", force: :cascade do |t|
    t.text     "name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "genders", force: :cascade do |t|
    t.text     "name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["name"], name: "index_genders_on_name", unique: true, using: :btree
  end

  create_table "indicators", force: :cascade do |t|
    t.text     "name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["name"], name: "index_indicators_on_name", unique: true, using: :btree
  end

  create_table "series", force: :cascade do |t|
    t.text     "name"
    t.text     "description"
    t.integer  "multiplier"
    t.boolean  "seasonally_adjusted"
    t.integer  "indicator_id",        null: false
    t.integer  "frequency_id",        null: false
    t.integer  "unit_id",             null: false
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.text     "gender_raw",          null: false
    t.integer  "gender_id",           null: false
    t.index ["frequency_id"], name: "index_series_on_frequency_id", using: :btree
    t.index ["gender_id"], name: "index_series_on_gender_id", using: :btree
    t.index ["indicator_id"], name: "index_series_on_indicator_id", using: :btree
    t.index ["name"], name: "index_series_on_name", unique: true, using: :btree
    t.index ["unit_id"], name: "index_series_on_unit_id", using: :btree
  end

  create_table "sources", force: :cascade do |t|
    t.string   "name"
    t.string   "internal_name"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "units", force: :cascade do |t|
    t.text     "name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "values", force: :cascade do |t|
    t.text     "raw_name"
    t.integer  "raw_year"
    t.text     "raw_period"
    t.text     "raw_value"
    t.date     "date"
    t.float    "value"
    t.integer  "series_id"
    t.integer  "indicator_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["indicator_id"], name: "index_values_on_indicator_id", using: :btree
    t.index ["raw_name", "raw_year", "raw_period", "raw_value"], name: "index_values_on_name_year_period_value", unique: true, using: :btree
    t.index ["series_id"], name: "index_values_on_series_id", using: :btree
  end

  add_foreign_key "series", "frequencies"
  add_foreign_key "series", "genders"
  add_foreign_key "series", "indicators"
  add_foreign_key "series", "units"
  add_foreign_key "values", "indicators"
  add_foreign_key "values", "series"
end
