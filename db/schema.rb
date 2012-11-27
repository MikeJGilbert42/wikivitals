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

ActiveRecord::Schema.define(:version => 20121127195432) do

  create_table "links", :force => true do |t|
    t.integer  "wiki_record_id"
    t.integer  "target_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "links", ["target_id"], :name => "index_links_on_target_id"
  add_index "links", ["wiki_record_id"], :name => "index_links_on_wiki_record_id"

  create_table "page_views", :force => true do |t|
    t.integer  "user_id"
    t.integer  "wiki_record_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "people", :force => true do |t|
    t.boolean  "alive"
    t.datetime "updated_at"
    t.string   "name"
    t.date     "death_date"
    t.string   "article_title"
    t.date     "birth_date"
  end

  add_index "people", ["article_title"], :name => "index_people_on_article_title", :unique => true

  create_table "users", :force => true do |t|
    t.string   "color"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "wiki_records", :force => true do |t|
    t.string   "article_title"
    t.string   "article_body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "redirect_id"
  end

  add_index "wiki_records", ["article_title"], :name => "index_wiki_records_on_article_title", :unique => true

end
