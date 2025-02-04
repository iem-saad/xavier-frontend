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

ActiveRecord::Schema[7.0].define(version: 2023_05_13_160846) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "mutated_models", force: :cascade do |t|
    t.bigint "original_model_id", null: false
    t.string "name", null: false
    t.string "description"
    t.binary "file", null: false
    t.jsonb "matrices", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["original_model_id"], name: "index_mutated_models_on_original_model_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.bigint "project_id"
    t.string "text"
    t.integer "n_type", default: 0
    t.boolean "seen", default: false
    t.index ["project_id"], name: "index_notifications_on_project_id"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "original_models", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.string "name", null: false
    t.string "description"
    t.binary "file", null: false
    t.jsonb "matrices", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_original_models_on_project_id"
  end

  create_table "project_report_chart_assets", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "project_id", null: false
    t.string "matric_type", null: false
    t.integer "model_no", null: false
    t.text "img_string", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_project_report_chart_assets_on_project_id"
    t.index ["user_id"], name: "index_project_report_chart_assets_on_user_id"
  end

  create_table "projects", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name", null: false
    t.string "description"
    t.jsonb "hyper_params", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0
    t.jsonb "results"
    t.index ["user_id"], name: "index_projects_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "mutated_models", "original_models"
  add_foreign_key "original_models", "projects"
  add_foreign_key "project_report_chart_assets", "projects"
  add_foreign_key "project_report_chart_assets", "users"
  add_foreign_key "projects", "users"
end
