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

ActiveRecord::Schema.define(version: 2019_08_20_111044) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "drawing_pins", force: :cascade do |t|
    t.string "pin_name", limit: 30, null: false
    t.text "pin_article", null: false
    t.string "address", limit: 255, null: false
    t.float "latitude", null: false
    t.float "longitude", null: false
    t.text "image"
    t.integer "public_div", limit: 2, default: 0, null: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "url", limit: 4096, default: "", null: false
    t.index ["user_id"], name: "index_drawing_pins_on_user_id"
  end

  create_table "plan_pins", force: :cascade do |t|
    t.bigint "plan_id"
    t.bigint "drawing_pin_id"
    t.string "plan_pin_name", limit: 30, null: false
    t.text "plan_pin_article", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position", default: 0, null: false
    t.integer "route", default: 1, null: false
    t.string "url", limit: 4096, default: "", null: false
    t.index ["drawing_pin_id"], name: "index_plan_pins_on_drawing_pin_id"
    t.index ["plan_id"], name: "index_plan_pins_on_plan_id"
  end

  create_table "plans", force: :cascade do |t|
    t.bigint "user_id"
    t.string "plan_name", limit: 20, null: false
    t.boolean "default_plan", default: false, null: false
    t.integer "public_div", limit: 2, default: 0, null: false
    t.string "password_digest"
    t.bigint "workbox_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "comment", limit: 40, default: "", null: false
    t.text "image"
    t.index ["user_id"], name: "index_plans_on_user_id"
    t.index ["workbox_id"], name: "index_plans_on_workbox_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name", null: false
    t.integer "div", null: false
    t.boolean "admin_flg", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "max_workbox_num", default: 4, null: false
    t.integer "max_plan_num", default: 24, null: false
    t.index ["div"], name: "index_roles_on_div", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "user_name", default: "", null: false
    t.string "account_name", default: "", null: false
    t.integer "email_public_div", default: 9, null: false
    t.text "profile", default: "", null: false
    t.integer "public_div", default: 0, null: false
    t.integer "pin_public_div_default", default: 0, null: false
    t.bigint "role_id"
    t.boolean "tutorial", default: true, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role_id"], name: "index_users_on_role_id"
    t.index ["user_name"], name: "index_users_on_user_name", unique: true
  end

  create_table "workbox_pins", force: :cascade do |t|
    t.bigint "workbox_id"
    t.bigint "drawing_pin_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["drawing_pin_id"], name: "index_workbox_pins_on_drawing_pin_id"
    t.index ["workbox_id"], name: "index_workbox_pins_on_workbox_id"
  end

  create_table "workboxes", force: :cascade do |t|
    t.bigint "user_id"
    t.string "workbox_name", limit: 12, null: false
    t.boolean "default_box", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_workboxes_on_user_id"
  end

  add_foreign_key "drawing_pins", "users"
  add_foreign_key "plan_pins", "drawing_pins"
  add_foreign_key "plan_pins", "plans"
  add_foreign_key "plans", "users"
  add_foreign_key "plans", "workboxes"
  add_foreign_key "users", "roles"
  add_foreign_key "workbox_pins", "drawing_pins"
  add_foreign_key "workbox_pins", "workboxes"
  add_foreign_key "workboxes", "users"
end
