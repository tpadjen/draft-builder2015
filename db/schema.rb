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

ActiveRecord::Schema.define(version: 20150828104008) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "draft_picks", force: :cascade do |t|
    t.integer  "number"
    t.integer  "nfl_player_id"
    t.integer  "fantasy_team_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "draft_picks", ["fantasy_team_id"], name: "index_draft_picks_on_fantasy_team_id", using: :btree
  add_index "draft_picks", ["nfl_player_id"], name: "index_draft_picks_on_nfl_player_id", using: :btree

  create_table "fantasy_teams", force: :cascade do |t|
    t.string   "owner"
    t.integer  "pick_number"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "nfl_players", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "rank"
    t.integer  "position_rank"
    t.decimal  "projected_points"
    t.integer  "nfl_team_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "position"
    t.decimal  "adp_ffc"
    t.decimal  "adp_round"
  end

  add_index "nfl_players", ["nfl_team_id"], name: "index_nfl_players_on_nfl_team_id", using: :btree

  create_table "nfl_teams", force: :cascade do |t|
    t.string   "nickname"
    t.string   "city"
    t.string   "shortname"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "draft_picks", "fantasy_teams"
  add_foreign_key "draft_picks", "nfl_players"
  add_foreign_key "nfl_players", "nfl_teams"
end
