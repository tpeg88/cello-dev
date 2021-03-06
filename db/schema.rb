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

ActiveRecord::Schema.define(version: 20140526185743) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "iterations", force: true do |t|
    t.integer  "project_id"
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "velocity"
  end

  add_index "iterations", ["project_id"], name: "index_iterations_on_project_id", using: :btree

  create_table "project_memberships", force: true do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "project_memberships", ["project_id"], name: "index_project_memberships_on_project_id", using: :btree
  add_index "project_memberships", ["user_id"], name: "index_project_memberships_on_user_id", using: :btree

  create_table "projects", force: true do |t|
    t.string   "title",                null: false
    t.string   "description"
    t.integer  "owner_id",             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "current_iteration_id"
  end

  add_index "projects", ["owner_id"], name: "index_projects_on_owner_id", using: :btree

  create_table "stories", force: true do |t|
    t.string   "title",          null: false
    t.string   "description"
    t.string   "story_type",     null: false
    t.string   "story_state",    null: false
    t.integer  "story_points"
    t.integer  "project_id",     null: false
    t.integer  "requester_id",   null: false
    t.integer  "owner_id"
    t.integer  "iteration_id"
    t.datetime "date_completed"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "story_rank",     null: false
  end

  add_index "stories", ["iteration_id"], name: "index_stories_on_iteration_id", using: :btree
  add_index "stories", ["owner_id"], name: "index_stories_on_owner_id", using: :btree
  add_index "stories", ["project_id"], name: "index_stories_on_project_id", using: :btree
  add_index "stories", ["requester_id"], name: "index_stories_on_requester_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",           null: false
    t.string   "password_digest", null: false
    t.string   "session_token",   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["session_token"], name: "index_users_on_session_token", unique: true, using: :btree

end
