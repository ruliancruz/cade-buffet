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

ActiveRecord::Schema[7.1].define(version: 2024_05_10_053522) do
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
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "base_prices", force: :cascade do |t|
    t.string "description", null: false
    t.float "minimum", null: false
    t.float "additional_per_person", null: false
    t.float "extra_hour_value"
    t.integer "event_type_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0, null: false
    t.index ["event_type_id"], name: "index_base_prices_on_event_type_id"
  end

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

  create_table "clients", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name"
    t.string "cpf"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_clients_on_email", unique: true
    t.index ["reset_password_token"], name: "index_clients_on_reset_password_token", unique: true
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
    t.integer "status", default: 0, null: false
    t.index ["buffet_id"], name: "index_event_types_on_buffet_id"
  end

  create_table "messages", force: :cascade do |t|
    t.string "text", null: false
    t.datetime "datetime", null: false
    t.integer "author", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "order_id", null: false
    t.index ["order_id"], name: "index_messages_on_order_id"
  end

  create_table "orders", force: :cascade do |t|
    t.date "date", null: false
    t.integer "attendees", null: false
    t.string "details", null: false
    t.string "code", null: false
    t.string "address"
    t.integer "status", null: false
    t.date "expiration_date"
    t.float "price_adjustment"
    t.string "price_adjustment_description"
    t.integer "client_id", null: false
    t.integer "event_type_id", null: false
    t.integer "payment_option_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "base_price_id"
    t.index ["base_price_id"], name: "index_orders_on_base_price_id"
    t.index ["client_id"], name: "index_orders_on_client_id"
    t.index ["event_type_id"], name: "index_orders_on_event_type_id"
    t.index ["payment_option_id"], name: "index_orders_on_payment_option_id"
  end

  create_table "payment_options", force: :cascade do |t|
    t.string "name", null: false
    t.integer "installment_limit"
    t.integer "buffet_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0, null: false
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

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "base_prices", "event_types"
  add_foreign_key "buffets", "buffet_owners"
  add_foreign_key "event_types", "buffets"
  add_foreign_key "messages", "orders"
  add_foreign_key "orders", "base_prices"
  add_foreign_key "orders", "clients"
  add_foreign_key "orders", "event_types"
  add_foreign_key "orders", "payment_options"
  add_foreign_key "payment_options", "buffets"
end
