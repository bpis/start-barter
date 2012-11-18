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

ActiveRecord::Schema.define(:version => 20121118152738) do

  create_table "countries", :force => true do |t|
    t.string   "name",       :default => "", :null => false
    t.string   "code",       :default => "", :null => false
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  create_table "profiles", :force => true do |t|
    t.integer  "user_id"
    t.string   "company_name"
    t.string   "tagline"
    t.string   "github_profile_link"
    t.string   "overview",            :limit => 1000
    t.string   "job_profile",         :limit => 8000
    t.string   "keyword"
    t.string   "phone_no"
    t.string   "address_line_1"
    t.string   "address_line_2"
    t.string   "city"
    t.string   "state"
    t.integer  "zip"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
  end

  create_table "skills", :force => true do |t|
    t.integer  "user_id"
    t.string   "skill_name"
    t.boolean  "visibility"
    t.string   "proficiency"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "first_name",             :default => "", :null => false
    t.string   "last_name",              :default => "", :null => false
    t.string   "username",               :default => "", :null => false
    t.string   "company_name",           :default => "", :null => false
    t.integer  "country_id",             :default => 0,  :null => false
    t.string   "provider"
    t.string   "uid"
    t.string   "about_me"
    t.date     "dob"
    t.string   "hometown"
    t.string   "location"
    t.string   "relationships"
    t.string   "status"
    t.string   "gender"
    t.string   "organisation"
    t.string   "designation"
    t.string   "profession"
    t.string   "facebook_url"
    t.string   "educational_details"
    t.string   "facebook_image"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.text     "iam"
    t.text     "iamlookingfor"
    t.string   "profile_picture"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
