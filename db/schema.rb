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

ActiveRecord::Schema.define(version: 2019_02_18_220042) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "holdings", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "wallet_id"
    t.uuid "stock_id"
    t.integer "quantity", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "invested", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "average_price", precision: 6, scale: 2, default: "0.0", null: false
    t.decimal "accounting_average_price", precision: 6, scale: 2, default: "0.0", null: false
    t.index ["stock_id"], name: "index_holdings_on_stock_id"
    t.index ["wallet_id"], name: "index_holdings_on_wallet_id"
  end

  create_table "operations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "wallet_id"
    t.uuid "stock_id"
    t.string "type"
    t.integer "quantity", null: false
    t.decimal "price", precision: 10, scale: 2, null: false
    t.decimal "taxes", precision: 6, scale: 2, default: "0.0", null: false
    t.decimal "total", precision: 10, scale: 2, null: false
    t.date "date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["stock_id"], name: "index_operations_on_stock_id"
    t.index ["wallet_id"], name: "index_operations_on_wallet_id"
  end

  create_table "quotes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "stock_id"
    t.date "date", null: false
    t.decimal "open", precision: 6, scale: 2, null: false
    t.decimal "close", precision: 6, scale: 2, null: false
    t.decimal "high", precision: 6, scale: 2, null: false
    t.decimal "low", precision: 6, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "volume", null: false
    t.index ["stock_id", "date"], name: "index_quotes_on_stock_id_and_date", unique: true
    t.index ["stock_id"], name: "index_quotes_on_stock_id"
  end

  create_table "sectors", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "stock_exchange_id"
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["stock_exchange_id"], name: "index_sectors_on_stock_exchange_id"
  end

  create_table "stock_exchanges", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "code", null: false
    t.string "alpha_vantage_code", null: false
    t.string "country", null: false
    t.string "timeonze", null: false
    t.string "open", null: false
    t.string "close", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["alpha_vantage_code"], name: "index_stock_exchanges_on_alpha_vantage_code", unique: true
    t.index ["code"], name: "index_stock_exchanges_on_code", unique: true
  end

  create_table "stocks", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "ticker", null: false
    t.string "type"
    t.uuid "stock_exchange_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "enabled", default: true
    t.uuid "sector_id"
    t.index ["sector_id"], name: "index_stocks_on_sector_id"
    t.index ["stock_exchange_id"], name: "index_stocks_on_stock_exchange_id"
    t.index ["ticker"], name: "index_stocks_on_ticker", unique: true
    t.index ["type"], name: "index_stocks_on_type"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
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

  create_table "wallets", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id"
    t.uuid "stock_exchange_id"
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["stock_exchange_id"], name: "index_wallets_on_stock_exchange_id"
    t.index ["user_id"], name: "index_wallets_on_user_id"
  end

  add_foreign_key "holdings", "stocks"
  add_foreign_key "holdings", "wallets"
  add_foreign_key "operations", "stocks"
  add_foreign_key "operations", "wallets"
  add_foreign_key "quotes", "stocks"
  add_foreign_key "sectors", "stock_exchanges"
  add_foreign_key "stocks", "sectors"
  add_foreign_key "stocks", "stock_exchanges"
  add_foreign_key "wallets", "stock_exchanges"
  add_foreign_key "wallets", "users"
end
