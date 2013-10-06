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

ActiveRecord::Schema.define(:version => 20130930060839) do

  create_table "registrations", :force => true do |t|
    t.integer  "tournament_id"
    t.string   "first_name",     :limit => 40
    t.string   "last_name",      :limit => 40
    t.string   "school",         :limit => 80
    t.string   "grade",          :limit => 2
    t.string   "section",        :limit => 40
    t.string   "uscf_member_id", :limit => 16
    t.string   "shirt_size",     :limit => 40
    t.integer  "rating"
    t.string   "status",         :limit => 40
    t.decimal  "score",                        :precision => 8, :scale => 1
    t.string   "prize",          :limit => 40
    t.string   "team_prize",     :limit => 40
    t.datetime "created_at",                                                 :null => false
    t.datetime "updated_at",                                                 :null => false
  end

  create_table "schedule_tournaments", :force => true do |t|
    t.integer  "schedule_id",   :null => false
    t.integer  "tournament_id", :null => false
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "schedule_tournaments", ["schedule_id", "tournament_id"], :name => "schedule_tournament_index", :unique => true

  create_table "schedules", :force => true do |t|
    t.string   "slug",       :null => false
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "sections", :force => true do |t|
    t.integer  "tournament_id",               :null => false
    t.string   "name",          :limit => 80, :null => false
    t.string   "slug",          :limit => 80, :null => false
    t.boolean  "rated",                       :null => false
    t.string   "status",        :limit => 40, :null => false
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  create_table "tournaments", :force => true do |t|
    t.string   "slug",                                 :null => false
    t.string   "name",                                 :null => false
    t.string   "location",                             :null => false
    t.date     "event_date",                           :null => false
    t.string   "short_description",                    :null => false
    t.string   "description_asciidoc", :limit => 4000
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
    t.string   "registration",         :limit => 8
    t.string   "registration_uri"
  end

end
