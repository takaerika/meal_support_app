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

ActiveRecord::Schema[7.1].define(version: 2025_08_26_051121) do
  create_table "invite_codes", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "supporter_id", null: false
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_invite_codes_on_code", unique: true
    t.index ["supporter_id"], name: "index_invite_codes_on_supporter_id"
  end

  create_table "meal_records", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "patient_id", null: false
    t.date "eaten_on", null: false
    t.integer "slot", null: false
    t.text "text"
    t.text "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["patient_id", "eaten_on", "slot"], name: "index_meals_on_patient_date_slot", unique: true
    t.index ["patient_id"], name: "index_meal_records_on_patient_id"
  end

  create_table "support_links", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "supporter_id", null: false
    t.bigint "patient_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["patient_id"], name: "index_support_links_on_patient_id"
    t.index ["supporter_id", "patient_id"], name: "index_support_links_on_supporter_id_and_patient_id", unique: true
    t.index ["supporter_id"], name: "index_support_links_on_supporter_id"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.integer "role", default: 0, null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role"], name: "index_users_on_role"
  end

  add_foreign_key "invite_codes", "users", column: "supporter_id"
  add_foreign_key "meal_records", "users", column: "patient_id"
  add_foreign_key "support_links", "users", column: "patient_id"
  add_foreign_key "support_links", "users", column: "supporter_id"
end
