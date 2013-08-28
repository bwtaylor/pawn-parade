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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130708001808) do

  create_table "schedule_tournaments", :force => true do |t|
    t.integer  "schedule_id",   :null => false
    t.integer  "tournament_id", :null => false
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "schedule_tournaments", ["schedule_id"], :name => "index_schedule_tournaments_on_schedule_id"

  create_table "schedules", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "tournaments", :force => true do |t|
    t.string   "slug",       :null => false
    t.string   "location",   :null => false
    t.date     "event_date", :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end