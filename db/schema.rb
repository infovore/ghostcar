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

ActiveRecord::Schema.define(:version => 20140415100703) do

  create_table "checkins", :force => true do |t|
    t.string   "user_id"
    t.string   "checkin_id"
    t.string   "shout"
    t.integer  "timestamp",       :limit => 8
    t.string   "venue_id"
    t.string   "venue_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "reposted",                     :default => false
    t.integer  "timezone_offset"
  end

  create_table "users", :force => true do |t|
    t.string   "access_token"
    t.string   "firstname"
    t.string   "lastname"
    t.string   "foursquare_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "secondary_access_token"
    t.string   "secondary_foursquare_id"
    t.string   "photo_prefix"
    t.string   "photo_suffix"
  end

end
