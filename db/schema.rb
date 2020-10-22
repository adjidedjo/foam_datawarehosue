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

ActiveRecord::Schema.define(version: 20171004030802) do

  create_table "areas", id: :bigint, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "area",   limit: 100
    t.string "jde_id", limit: 7
  end

  create_table "outstanding_orders", id: :bigint, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "order_no"
    t.string   "customer"
    t.date     "promised_delivery"
    t.string   "brand",             limit: 200
    t.datetime "updated_at"
    t.string   "branch",            limit: 11
    t.string   "item_number",       limit: 50
    t.string   "description"
    t.date     "order_date"
    t.integer  "quantity"
    t.string   "short_item",        limit: 50
    t.string   "segment1",          limit: 5
    t.datetime "created_at"
  end

  create_table "outstanding_productions", id: :bigint, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "short_item",        limit: 50
    t.string   "item_number",       limit: 150
    t.string   "description",       limit: 250
    t.string   "segment1",          limit: 5
    t.string   "brand",             limit: 100
    t.string   "branch",            limit: 10
    t.integer  "order_in",                      default: 0
    t.integer  "outstanding_order",             default: 0
    t.integer  "buffer",                        default: 0
    t.integer  "stock_f",                       default: 0
    t.integer  "stock_c",                       default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "onhand"
  end

  create_table "sales_orders", id: :bigint, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "brand",       limit: 200
    t.datetime "updated_at"
    t.string   "branch",      limit: 50
    t.string   "item_number", limit: 50
    t.string   "description"
    t.integer  "quantity"
    t.string   "short_item",  limit: 50
  end

  create_table "stocks", id: :bigint, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "description", limit: 100
    t.bigint   "onhand"
    t.bigint   "available"
    t.bigint   "buffer",                  default: 0
    t.string   "branch",      limit: 20
    t.string   "brand",       limit: 100
    t.string   "status",      limit: 1
    t.string   "item_number", limit: 100
    t.bigint   "item_cost"
    t.datetime "updated_at"
    t.string   "product",     limit: 5
    t.string   "short_item"
    t.index ["branch", "brand", "item_number", "onhand", "status"], name: "indexes1", using: :btree
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "username"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

end
