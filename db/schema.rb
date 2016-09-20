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

ActiveRecord::Schema.define(version: 20160919005644) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_trgm"
  enable_extension "fuzzystrmatch"

  create_table "age_brackets", force: :cascade do |t|
    t.text     "name"
    t.text     "description"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.text     "internal_name", null: false
    t.index ["internal_name"], name: "index_age_brackets_on_internal_name", unique: true, using: :btree
    t.index ["name"], name: "index_age_brackets_on_name", unique: true, using: :btree
  end

  create_table "categories", force: :cascade do |t|
    t.text     "name"
    t.text     "description"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.text     "internal_name", null: false
    t.index ["internal_name"], name: "index_categories_on_internal_name", unique: true, using: :btree
    t.index ["name"], name: "index_categories_on_name", unique: true, using: :btree
  end

  create_table "child_statuses", force: :cascade do |t|
    t.text     "name"
    t.text     "description"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.text     "internal_name", null: false
    t.index ["internal_name"], name: "index_child_statuses_on_internal_name", unique: true, using: :btree
    t.index ["name"], name: "index_child_statuses_on_name", unique: true, using: :btree
  end

  create_table "dashboard_items", force: :cascade do |t|
    t.integer "dashboard_id", null: false
    t.integer "user_id",      null: false
    t.integer "indicator_id", null: false
    t.integer "series_id"
    t.integer "sort_order"
    t.index ["dashboard_id"], name: "index_dashboard_items_on_dashboard_id", using: :btree
    t.index ["indicator_id"], name: "index_dashboard_items_on_indicator_id", using: :btree
    t.index ["series_id"], name: "index_dashboard_items_on_series_id", using: :btree
    t.index ["user_id"], name: "index_dashboard_items_on_user_id", using: :btree
  end

  create_table "dashboards", force: :cascade do |t|
    t.text     "name"
    t.text     "description"
    t.integer  "user_id",     null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["user_id"], name: "index_dashboards_on_user_id", using: :btree
  end

  create_table "datasets", force: :cascade do |t|
    t.text     "name"
    t.text     "internal_name"
    t.integer  "source_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.text     "description"
    t.integer  "category_id",   null: false
    t.index ["category_id"], name: "index_datasets_on_category_id", using: :btree
    t.index ["internal_name"], name: "index_datasets_on_internal_name", unique: true, using: :btree
    t.index ["name"], name: "index_datasets_on_name", unique: true, using: :btree
    t.index ["source_id"], name: "index_datasets_on_source_id", using: :btree
  end

  create_table "education_levels", force: :cascade do |t|
    t.text     "name"
    t.text     "description"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.text     "internal_name", null: false
    t.index ["internal_name"], name: "index_education_levels_on_internal_name", unique: true, using: :btree
    t.index ["name"], name: "index_education_levels_on_name", unique: true, using: :btree
  end

  create_table "employment_statuses", force: :cascade do |t|
    t.text     "name"
    t.text     "description"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.text     "internal_name", null: false
    t.index ["internal_name"], name: "index_employment_statuses_on_internal_name", unique: true, using: :btree
    t.index ["name"], name: "index_employment_statuses_on_name", unique: true, using: :btree
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
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.text     "internal_name", null: false
    t.index ["internal_name"], name: "index_frequencies_on_internal_name", unique: true, using: :btree
  end

  create_table "genders", force: :cascade do |t|
    t.text     "name"
    t.text     "description"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.text     "internal_name", null: false
    t.index ["internal_name"], name: "index_genders_on_internal_name", unique: true, using: :btree
    t.index ["name"], name: "index_genders_on_name", unique: true, using: :btree
  end

  create_table "geo_codes", force: :cascade do |t|
    t.text     "name"
    t.text     "description"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.text     "internal_name", null: false
    t.text     "type"
    t.integer  "fips_code"
    t.text     "short_name"
    t.integer  "gnis_code"
    t.index ["internal_name"], name: "index_geo_codes_on_internal_name", unique: true, using: :btree
    t.index ["type", "internal_name"], name: "index_geo_codes_on_type_and_internal_name", unique: true, using: :btree
  end

  create_table "income_levels", force: :cascade do |t|
    t.text     "name"
    t.text     "description"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.text     "internal_name", null: false
    t.index ["internal_name"], name: "index_income_levels_on_internal_name", unique: true, using: :btree
    t.index ["name"], name: "index_income_levels_on_name", unique: true, using: :btree
  end

  create_table "indicators", force: :cascade do |t|
    t.text     "name"
    t.text     "description"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "source_id",         null: false
    t.integer  "category_id",       null: false
    t.integer  "dataset_id",        null: false
    t.text     "internal_name",     null: false
    t.text     "source_identifier", null: false
    t.tsvector "tsv"
    t.index ["category_id"], name: "index_indicators_on_category_id", using: :btree
    t.index ["dataset_id"], name: "index_indicators_on_dataset_id", using: :btree
    t.index ["internal_name"], name: "index_indicators_on_internal_name", unique: true, using: :btree
    t.index ["name"], name: "index_indicators_on_name", unique: true, using: :btree
    t.index ["source_id"], name: "index_indicators_on_source_id", using: :btree
    t.index ["tsv"], name: "index_indicators_on_tsv", using: :gin
  end

  create_table "industry_codes", force: :cascade do |t|
    t.text     "name"
    t.text     "description"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.text     "internal_name", null: false
    t.text     "industry_type"
    t.integer  "naics_code"
    t.index ["internal_name"], name: "index_industry_codes_on_internal_name", unique: true, using: :btree
    t.index ["name"], name: "index_industry_codes_on_name", unique: true, using: :btree
  end

  create_table "marital_statuses", force: :cascade do |t|
    t.text     "name"
    t.text     "description"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.text     "internal_name", null: false
    t.index ["internal_name"], name: "index_marital_statuses_on_internal_name", unique: true, using: :btree
    t.index ["name"], name: "index_marital_statuses_on_name", unique: true, using: :btree
  end

  create_table "occupation_codes", force: :cascade do |t|
    t.text     "name"
    t.text     "description"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.text     "internal_name", null: false
    t.index ["internal_name"], name: "index_occupation_codes_on_internal_name", unique: true, using: :btree
    t.index ["name"], name: "index_occupation_codes_on_name", unique: true, using: :btree
  end

  create_table "races", force: :cascade do |t|
    t.text     "name"
    t.text     "description"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.text     "internal_name", null: false
    t.index ["internal_name"], name: "index_races_on_internal_name", unique: true, using: :btree
    t.index ["name"], name: "index_races_on_name", unique: true, using: :btree
  end

  create_table "series", force: :cascade do |t|
    t.text     "name"
    t.text     "description"
    t.integer  "multiplier"
    t.boolean  "seasonally_adjusted"
    t.integer  "indicator_id",          null: false
    t.integer  "frequency_id",          null: false
    t.integer  "unit_id",               null: false
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.text     "gender_raw"
    t.integer  "gender_id",             null: false
    t.text     "race_raw"
    t.integer  "race_id",               null: false
    t.text     "marital_status_raw"
    t.integer  "marital_status_id",     null: false
    t.text     "age_bracket_raw"
    t.integer  "age_bracket_id",        null: false
    t.text     "employment_status_raw"
    t.integer  "employment_status_id",  null: false
    t.text     "education_level_raw"
    t.integer  "education_level_id",    null: false
    t.text     "child_status_raw"
    t.integer  "child_status_id",       null: false
    t.text     "income_level_raw"
    t.integer  "income_level_id",       null: false
    t.text     "industry_code_raw"
    t.integer  "industry_code_id",      null: false
    t.text     "occupation_code_raw"
    t.integer  "occupation_code_id",    null: false
    t.text     "geo_code_raw"
    t.integer  "geo_code_id",           null: false
    t.text     "internal_name",         null: false
    t.text     "source_identifier",     null: false
    t.index ["age_bracket_id"], name: "index_series_on_age_bracket_id", using: :btree
    t.index ["child_status_id"], name: "index_series_on_child_status_id", using: :btree
    t.index ["education_level_id"], name: "index_series_on_education_level_id", using: :btree
    t.index ["employment_status_id"], name: "index_series_on_employment_status_id", using: :btree
    t.index ["frequency_id"], name: "index_series_on_frequency_id", using: :btree
    t.index ["gender_id"], name: "index_series_on_gender_id", using: :btree
    t.index ["geo_code_id"], name: "index_series_on_geo_code_id", using: :btree
    t.index ["income_level_id"], name: "index_series_on_income_level_id", using: :btree
    t.index ["indicator_id"], name: "index_series_on_indicator_id", using: :btree
    t.index ["industry_code_id"], name: "index_series_on_industry_code_id", using: :btree
    t.index ["internal_name"], name: "index_series_on_internal_name", unique: true, using: :btree
    t.index ["marital_status_id"], name: "index_series_on_marital_status_id", using: :btree
    t.index ["name"], name: "index_series_on_name", unique: true, using: :btree
    t.index ["occupation_code_id"], name: "index_series_on_occupation_code_id", using: :btree
    t.index ["race_id"], name: "index_series_on_race_id", using: :btree
    t.index ["unit_id"], name: "index_series_on_unit_id", using: :btree
  end

  create_table "sources", force: :cascade do |t|
    t.text     "name"
    t.text     "internal_name"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["internal_name"], name: "index_sources_on_internal_name", unique: true, using: :btree
    t.index ["name"], name: "index_sources_on_name", unique: true, using: :btree
  end

  create_table "units", force: :cascade do |t|
    t.text     "name"
    t.text     "description"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.text     "internal_name", null: false
    t.index ["internal_name"], name: "index_units_on_internal_name", unique: true, using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
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

  add_foreign_key "datasets", "categories"
  add_foreign_key "indicators", "categories"
  add_foreign_key "indicators", "datasets"
  add_foreign_key "indicators", "sources"
  add_foreign_key "series", "age_brackets"
  add_foreign_key "series", "child_statuses"
  add_foreign_key "series", "education_levels"
  add_foreign_key "series", "employment_statuses"
  add_foreign_key "series", "frequencies"
  add_foreign_key "series", "genders"
  add_foreign_key "series", "geo_codes"
  add_foreign_key "series", "income_levels"
  add_foreign_key "series", "indicators"
  add_foreign_key "series", "industry_codes"
  add_foreign_key "series", "marital_statuses"
  add_foreign_key "series", "occupation_codes"
  add_foreign_key "series", "races"
  add_foreign_key "series", "units"
  add_foreign_key "values", "indicators"
  add_foreign_key "values", "series"
end
