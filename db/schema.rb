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

ActiveRecord::Schema.define(:version => 20140301084932) do

  create_table "guardians", :force => true do |t|
    t.integer  "player_id",  :null => false
    t.string   "email",      :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "players", :force => true do |t|
    t.string   "first_name",           :limit => 40, :null => false
    t.string   "last_name",            :limit => 40, :null => false
    t.string   "grade",                :limit => 2,  :null => false
    t.string   "school_year",          :limit => 10
    t.string   "uscf_id",              :limit => 10
    t.integer  "uscf_rating_reg"
    t.integer  "uscf_rating_reg_live"
    t.string   "uscf_status",          :limit => 12
    t.date     "uscf_expires"
    t.date     "date_of_birth"
    t.string   "address",              :limit => 80
    t.string   "address2",             :limit => 80
    t.string   "city",                 :limit => 40
    t.string   "state",                :limit => 12
    t.string   "zip_code",             :limit => 10
    t.string   "county",               :limit => 32
    t.string   "gender",               :limit => 1
    t.integer  "team_id"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  add_index "players", ["team_id"], :name => "index_players_on_team_id"

  create_table "registrations", :force => true do |t|
    t.integer  "tournament_id"
    t.string   "first_name",      :limit => 40
    t.string   "last_name",       :limit => 40
    t.string   "school",          :limit => 80
    t.string   "grade",           :limit => 2
    t.string   "section",         :limit => 40
    t.string   "uscf_member_id",  :limit => 16
    t.string   "shirt_size",      :limit => 40
    t.integer  "rating"
    t.string   "status",          :limit => 40
    t.decimal  "score",                          :precision => 8, :scale => 1
    t.string   "prize",           :limit => 40
    t.string   "team_prize",      :limit => 40
    t.datetime "created_at",                                                   :null => false
    t.datetime "updated_at",                                                   :null => false
    t.integer  "player_id"
    t.string   "guardian_emails", :limit => 512
    t.date     "date_of_birth"
    t.string   "address",         :limit => 80
    t.string   "city",            :limit => 40
    t.string   "state",           :limit => 12
    t.string   "zip_code",        :limit => 10
    t.string   "county",          :limit => 32
    t.string   "gender",          :limit => 1
    t.string   "team_slug",       :limit => 6
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
    t.integer  "max"
    t.integer  "rating_cap"
    t.integer  "grade_min"
    t.integer  "grade_max"
  end

  create_table "team_managers", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.integer  "team_id",    :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "teams", :force => true do |t|
    t.string   "name",              :limit => 32, :null => false
    t.string   "slug",              :limit => 6,  :null => false
    t.string   "full_name",         :limit => 64
    t.string   "city",              :limit => 32
    t.string   "county",            :limit => 32
    t.string   "state",             :limit => 2
    t.string   "school_district",   :limit => 32
    t.string   "uscf_affiliate_id", :limit => 12
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
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

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "",    :null => false
    t.string   "encrypted_password",     :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0,     :null => false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.boolean  "admin",                  :default => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
