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

ActiveRecord::Schema.define(version: 20170218155517) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string   "email",              default: "", null: false
    t.string   "encrypted_password", default: "", null: false
    t.integer  "sign_in_count",      default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["email"], name: "index_admins_on_email", unique: true, using: :btree
  end

  create_table "axes", force: :cascade do |t|
    t.integer  "theme_id"
    t.string   "title"
    t.text     "description"
    t.integer  "position"
    t.boolean  "enabled",     default: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.index ["theme_id"], name: "index_axes_on_theme_id", using: :btree
  end

  create_table "basic_pages", force: :cascade do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "position"
    t.boolean  "enabled",    default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "seos", force: :cascade do |t|
    t.string   "slug"
    t.string   "title"
    t.string   "keywords"
    t.text     "description"
    t.string   "seoable_type"
    t.integer  "seoable_id"
    t.string   "param"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["seoable_type", "seoable_id"], name: "index_seos_on_seoable_type_and_seoable_id", using: :btree
  end

  create_table "themes", force: :cascade do |t|
    t.string   "title"
    t.integer  "position"
    t.boolean  "enabled",    default: false
    t.string   "id_key"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "tool_categories", force: :cascade do |t|
    t.string   "title",                       null: false
    t.text     "description"
    t.integer  "position"
    t.boolean  "enabled",     default: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "tools", force: :cascade do |t|
    t.integer  "axis_id",                          null: false
    t.integer  "tool_category_id",                 null: false
    t.integer  "state",            default: 0,     null: false
    t.string   "title"
    t.text     "description"
    t.integer  "group_size",       default: 0
    t.integer  "duration",         default: 0
    t.integer  "level",            default: 0
    t.integer  "public",           default: 0
    t.integer  "licence",          default: 0
    t.string   "goal"
    t.text     "material"
    t.string   "source"
    t.string   "source_url"
    t.string   "submitter_email"
    t.boolean  "enabled",          default: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.index ["axis_id"], name: "index_tools_on_axis_id", using: :btree
    t.index ["tool_category_id"], name: "index_tools_on_tool_category_id", using: :btree
  end

  add_foreign_key "axes", "themes"
  add_foreign_key "tools", "axes"
  add_foreign_key "tools", "tool_categories"
end
