# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140611141337) do

  create_table "apps", :force => true do |t|
    t.string   "appid"
    t.string   "name"
    t.string   "desc"
    t.integer  "uid"
    t.string   "dt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "apps", ["appid"], :name => "index_apps_on_appid", :unique => true
  add_index "apps", ["name"], :name => "index_apps_on_name", :unique => true

  create_table "pubapps", :force => true do |t|
    t.string   "appid"
    t.string   "name"
    t.string   "desc"
    t.integer  "uid"
    t.string   "ver"
    t.text     "prop"
    t.integer  "type"
    t.integer  "cat1"
    t.integer  "cat2"
    t.integer  "cat3"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pubapps", ["appid"], :name => "index_pubapps_on_appid", :unique => true
  add_index "pubapps", ["name"], :name => "index_pubapps_on_name", :unique => true

end
