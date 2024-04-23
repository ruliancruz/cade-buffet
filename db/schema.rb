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

ActiveRecord::Schema[7.1].define(version: 2024_04_23_032208) do
  create_table "buffet_owners", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_buffet_owners_on_email", unique: true
    t.index ["reset_password_token"], name: "index_buffet_owners_on_reset_password_token", unique: true
  end

  create_table "buffets", force: :cascade do |t|
    t.string "brand_name", null: false
    t.string "corporate_name", null: false
    t.string "cnpj", null: false
    t.string "phone", null: false
    t.string "address", null: false
    t.string "district", null: false
    t.string "city", null: false
    t.string "state", null: false
    t.string "cep", null: false
    t.string "description"
    t.integer "buffet_owner_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["buffet_owner_id"], name: "index_buffets_on_buffet_owner_id"
  end

  create_table "event_types", force: :cascade do |t|
    t.string "name", null: false
    t.string "description", null: false
    t.integer "minimum_attendees", null: false
    t.integer "maximum_attendees", null: false
    t.integer "duration", null: false
    t.string "menu", null: false
    t.integer "provides_alcohol_drinks", null: false
    t.integer "provides_decoration", null: false
    t.integer "provides_parking_service", null: false
    t.integer "serves_external_address", null: false
    t.integer "buffet_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["buffet_id"], name: "index_event_types_on_buffet_id"
  end

  create_table "payment_options", force: :cascade do |t|
    t.string "name", null: false
    t.integer "installment_limit"
    t.integer "buffet_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["buffet_id"], name: "index_payment_options_on_buffet_id"
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

  add_foreign_key "buffets", "buffet_owners"
  add_foreign_key "event_types", "buffets"
  add_foreign_key "payment_options", "buffets"
end
