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

ActiveRecord::Schema[7.1].define(version: 2024_07_09_114926) do
  create_table "app_opens", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "source_ip"
    t.string "version_name"
    t.string "version_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_app_opens_on_user_id"
  end

  create_table "coupon_categories", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "img_url"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "coupon_offers", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.bigint "coupon_store_id", null: false
    t.bigint "coupon_category_id", null: false
    t.bigint "coupon_sub_category_id", null: false
    t.string "status"
    t.string "short_desc"
    t.text "long_desc"
    t.string "country"
    t.string "payout_type"
    t.string "shop_type"
    t.string "payout_cashback"
    t.string "income_cashback"
    t.string "offer_type"
    t.string "img_url"
    t.string "action_url"
    t.string "hindi_desc"
    t.string "currency"
    t.string "priority"
    t.string "code_show_text"
    t.string "code_show_value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["coupon_category_id"], name: "index_coupon_offers_on_coupon_category_id"
    t.index ["coupon_store_id"], name: "index_coupon_offers_on_coupon_store_id"
    t.index ["coupon_sub_category_id"], name: "index_coupon_offers_on_coupon_sub_category_id"
  end

  create_table "coupon_stores", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "coupon_category_id", null: false
    t.string "name"
    t.string "cashback"
    t.string "action_url"
    t.string "img_url"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["coupon_category_id"], name: "index_coupon_stores_on_coupon_category_id"
  end

  create_table "coupon_sub_categories", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "coupon_category_id", null: false
    t.string "name"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["coupon_category_id"], name: "index_coupon_sub_categories_on_coupon_category_id"
  end

  create_table "notifications", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "title"
    t.text "subtitle"
    t.string "image_url"
    t.bigint "coupon_offer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["coupon_offer_id"], name: "index_notifications_on_coupon_offer_id"
  end

  create_table "payouts", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "payout_name"
    t.string "payout_img_url"
    t.string "payout_amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "redeem_histories", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "upi_id"
    t.float "coins"
    t.string "phone"
    t.string "amount"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status", default: "PENDING"
    t.string "payout_id"
    t.index ["user_id"], name: "index_redeem_histories_on_user_id"
  end

  create_table "transaction_histories", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "trans_type"
    t.string "name"
    t.string "coins", default: "0"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_transaction_histories_on_user_id"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "device_id"
    t.string "device_type"
    t.string "device_name"
    t.string "social_type"
    t.string "social_id"
    t.string "social_token"
    t.string "social_email"
    t.string "social_name"
    t.string "social_img_url"
    t.string "advertising_id"
    t.string "version_name"
    t.string "version_code"
    t.string "utm_source"
    t.string "utm_medium"
    t.string "utm_content"
    t.string "utm_term"
    t.string "utm_campaign"
    t.string "referrer_url"
    t.string "source_ip"
    t.string "refer_code"
    t.string "security_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "wallet_balance", default: 0.0
    t.datetime "last_check_in"
    t.string "phone"
  end

  create_table "web_users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "social_name"
    t.string "social_email"
    t.string "social_img_url"
    t.string "social_token"
    t.string "social_type"
    t.string "source_ip"
    t.string "security_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "app_opens", "users"
  add_foreign_key "coupon_offers", "coupon_categories"
  add_foreign_key "coupon_offers", "coupon_stores"
  add_foreign_key "coupon_offers", "coupon_sub_categories"
  add_foreign_key "coupon_stores", "coupon_categories"
  add_foreign_key "coupon_sub_categories", "coupon_categories"
  add_foreign_key "notifications", "coupon_offers"
  add_foreign_key "redeem_histories", "users"
  add_foreign_key "transaction_histories", "users"
end
