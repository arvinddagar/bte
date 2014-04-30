# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20140430105009) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "students", force: true do |t|
    t.string   "username",   null: false
    t.integer  "user_id",    null: false
    t.hstore   "properties"
    t.string   "time_zone"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "students", ["properties"], name: "students_properties", using: :gin
  add_index "students", ["user_id"], name: "index_students_on_user_id", unique: true, using: :btree
  add_index "students", ["username"], name: "index_students_on_username", unique: true, using: :btree

  create_table "time_slots", force: true do |t|
    t.integer  "tutor_id"
    t.integer  "lesson_duration"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "starts_at_minutes"
  end

  add_index "time_slots", ["tutor_id"], name: "index_time_slots_on_tutor_id", using: :btree

  create_table "tutors", force: true do |t|
    t.string   "name"
    t.integer  "user_id",                                   null: false
    t.hstore   "properties"
    t.integer  "time_slots_count",           default: 0
    t.integer  "weeks_visible",    limit: 2, default: 52
    t.integer  "green_zone",                 default: 1440
    t.string   "time_zone"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tutors", ["properties"], name: "tutors_properties", using: :gin
  add_index "tutors", ["user_id"], name: "index_tutors_on_user_id", unique: true, using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.boolean  "admin",                  default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
