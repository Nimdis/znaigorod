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

ActiveRecord::Schema.define(:version => 20130315092229) do

  create_table "activities", :force => true do |t|
    t.text     "title"
    t.integer  "organization_id"
    t.integer  "user_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "status"
    t.string   "state"
    t.datetime "activity_at"
    t.integer  "contact_id"
  end

  add_index "activities", ["organization_id"], :name => "index_activities_on_organization_id"
  add_index "activities", ["user_id"], :name => "index_activities_on_user_id"

  create_table "addresses", :force => true do |t|
    t.string   "street"
    t.string   "house"
    t.integer  "organization_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "latitude"
    t.string   "longitude"
  end

  add_index "addresses", ["organization_id"], :name => "index_addresses_on_organization_id"

  create_table "affiche_schedules", :force => true do |t|
    t.integer  "affiche_id"
    t.date     "starts_on"
    t.date     "ends_on"
    t.time     "starts_at"
    t.time     "ends_at"
    t.string   "holidays"
    t.string   "place"
    t.string   "hall"
    t.integer  "price_min"
    t.integer  "price_max"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "organization_id"
    t.string   "latitude"
    t.string   "longitude"
  end

  add_index "affiche_schedules", ["affiche_id"], :name => "index_affiche_schedules_on_affiche_id"

  create_table "affiches", :force => true do |t|
    t.string   "title"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.text     "description"
    t.string   "original_title"
    t.string   "poster_url"
    t.text     "trailer_code"
    t.string   "type"
    t.text     "tag"
    t.string   "vfs_path"
    t.string   "image_url"
    t.datetime "distribution_starts_on"
    t.datetime "distribution_ends_on"
    t.string   "slug"
    t.boolean  "constant"
    t.integer  "yandex_metrika_page_views"
    t.integer  "vkontakte_likes"
    t.string   "vk_aid"
    t.string   "yandex_fotki_url"
    t.float    "popularity"
    t.integer  "age_min"
    t.integer  "age_max"
  end

  add_index "affiches", ["slug"], :name => "index_affiches_on_slug", :unique => true

  create_table "attachments", :force => true do |t|
    t.integer  "attachable_id"
    t.string   "attachable_type"
    t.string   "url"
    t.text     "description"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "contacts", :force => true do |t|
    t.string   "full_name"
    t.string   "post"
    t.string   "phone"
    t.string   "mobile_phone"
    t.string   "email"
    t.string   "skype"
    t.string   "vkontakte"
    t.string   "facebook"
    t.integer  "organization_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "contacts", ["organization_id"], :name => "index_contacts_on_organization_id"

  create_table "contests", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.date     "starts_on"
    t.date     "ends_on"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "vfs_path"
    t.string   "slug"
  end

  add_index "contests", ["slug"], :name => "index_contests_on_slug", :unique => true

  create_table "creations", :force => true do |t|
    t.integer  "organization_id"
    t.string   "title"
    t.text     "description"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "creations", ["organization_id"], :name => "index_creations_on_organization_id"

  create_table "cultures", :force => true do |t|
    t.text     "category"
    t.text     "feature"
    t.text     "offer"
    t.string   "payment"
    t.integer  "organization_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "title"
    t.text     "description"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "entertainments", :force => true do |t|
    t.text     "category"
    t.text     "feature"
    t.text     "offer"
    t.string   "payment"
    t.integer  "organization_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "title"
    t.text     "description"
    t.string   "type"
  end

  add_index "entertainments", ["organization_id"], :name => "index_entertainments_on_organization_id"

  create_table "feedbacks", :force => true do |t|
    t.string   "email"
    t.text     "message"
    t.string   "fullname"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "halls", :force => true do |t|
    t.string   "title"
    t.integer  "seating_capacity"
    t.integer  "organization_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "halls", ["organization_id"], :name => "index_halls_on_organization_id"

  create_table "images", :force => true do |t|
    t.text     "url"
    t.integer  "imageable_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.text     "description"
    t.string   "imageable_type"
    t.string   "thumbnail_url"
    t.integer  "width"
    t.integer  "height"
  end

  add_index "images", ["imageable_id"], :name => "index_images_on_organization_id"

  create_table "meals", :force => true do |t|
    t.text     "category"
    t.text     "feature"
    t.text     "offer"
    t.string   "payment"
    t.text     "cuisine"
    t.integer  "organization_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "title"
    t.text     "description"
  end

  add_index "meals", ["organization_id"], :name => "index_meals_on_organization_id"

  create_table "organization_stands", :force => true do |t|
    t.integer  "organization_id"
    t.integer  "places"
    t.boolean  "guarded"
    t.boolean  "video_observation"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "organization_stands", ["organization_id"], :name => "index_organization_stands_on_organization_id"

  create_table "organizations", :force => true do |t|
    t.text     "title"
    t.text     "site"
    t.text     "email"
    t.text     "description"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.text     "phone"
    t.string   "vfs_path"
    t.integer  "organization_id"
    t.text     "logotype_url"
    t.string   "slug"
    t.text     "tour_link"
    t.float    "rating"
    t.boolean  "non_cash"
    t.string   "priority_suborganization_kind"
    t.text     "comment"
    t.integer  "additional_rating"
    t.integer  "yandex_metrika_page_views"
    t.integer  "vkontakte_likes"
    t.string   "subdomain"
    t.integer  "user_id"
    t.string   "status"
  end

  add_index "organizations", ["slug"], :name => "index_organizations_on_slug", :unique => true
  add_index "organizations", ["user_id"], :name => "index_organizations_on_user_id"

  create_table "pool_table_prices", :force => true do |t|
    t.integer  "pool_table_id"
    t.integer  "day"
    t.time     "from"
    t.time     "to"
    t.integer  "price"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "pool_table_prices", ["pool_table_id"], :name => "index_pool_table_prices_on_pool_table_id"

  create_table "pool_tables", :force => true do |t|
    t.integer  "size"
    t.integer  "count"
    t.string   "kind"
    t.integer  "billiard_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "pool_tables", ["billiard_id"], :name => "index_pool_tables_on_billiard_id"

  create_table "post_images", :force => true do |t|
    t.string   "title"
    t.integer  "post_id"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.text     "attachment_url"
  end

  add_index "post_images", ["post_id"], :name => "index_post_images_on_post_id"

  create_table "posts", :force => true do |t|
    t.text     "title"
    t.text     "annotation"
    t.text     "content"
    t.text     "poster_url"
    t.string   "vfs_path"
    t.string   "slug"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "status",     :default => false
  end

  create_table "sauna_accessories", :force => true do |t|
    t.integer  "sauna_id"
    t.integer  "sheets"
    t.integer  "sneakers"
    t.integer  "bathrobes"
    t.integer  "towels"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.boolean  "ware"
  end

  add_index "sauna_accessories", ["sauna_id"], :name => "index_sauna_accessories_on_sauna_id"

  create_table "sauna_alcohols", :force => true do |t|
    t.integer  "sauna_id"
    t.integer  "ability_own"
    t.boolean  "sale"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "sauna_alcohols", ["sauna_id"], :name => "index_sauna_alcohols_on_sauna_id"

  create_table "sauna_brooms", :force => true do |t|
    t.integer  "sauna_id"
    t.integer  "ability"
    t.integer  "sale"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sauna_brooms", ["sauna_id"], :name => "index_sauna_brooms_on_sauna_id"

  create_table "sauna_child_stuffs", :force => true do |t|
    t.integer  "sauna_id"
    t.integer  "life_jacket"
    t.integer  "cartoons"
    t.integer  "games"
    t.integer  "rubber_ring"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "sauna_child_stuffs", ["sauna_id"], :name => "index_sauna_child_stuffs_on_sauna_id"

  create_table "sauna_hall_baths", :force => true do |t|
    t.integer  "sauna_hall_id"
    t.boolean  "russian"
    t.boolean  "finnish"
    t.boolean  "turkish"
    t.boolean  "japanese"
    t.boolean  "infrared"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "sauna_hall_baths", ["sauna_hall_id"], :name => "index_sauna_hall_baths_on_sauna_hall_id"

  create_table "sauna_hall_capacities", :force => true do |t|
    t.integer  "sauna_hall_id"
    t.integer  "default"
    t.integer  "maximal"
    t.integer  "extra_guest_cost"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "sauna_hall_entertainments", :force => true do |t|
    t.integer  "sauna_hall_id"
    t.integer  "karaoke"
    t.integer  "tv"
    t.integer  "billiard"
    t.integer  "ping_pong"
    t.integer  "hookah"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "aerohockey"
    t.integer  "checkers"
    t.integer  "chess"
    t.integer  "backgammon"
    t.integer  "guitar"
  end

  add_index "sauna_hall_entertainments", ["sauna_hall_id"], :name => "index_sauna_hall_entertainments_on_sauna_hall_id"

  create_table "sauna_hall_interiors", :force => true do |t|
    t.integer  "sauna_hall_id"
    t.integer  "floors"
    t.integer  "lounges"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.boolean  "pit"
    t.boolean  "pylon"
    t.boolean  "barbecue"
  end

  add_index "sauna_hall_interiors", ["sauna_hall_id"], :name => "index_sauna_hall_interiors_on_sauna_hall_id"

  create_table "sauna_hall_pools", :force => true do |t|
    t.integer  "sauna_hall_id"
    t.string   "size"
    t.boolean  "contraflow"
    t.boolean  "geyser"
    t.boolean  "waterfall"
    t.string   "water_filter"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "jacuzzi"
    t.integer  "bucket"
  end

  add_index "sauna_hall_pools", ["sauna_hall_id"], :name => "index_sauna_hall_pools_on_sauna_hall_id"

  create_table "sauna_hall_schedules", :force => true do |t|
    t.integer  "sauna_hall_id"
    t.integer  "day"
    t.time     "from"
    t.time     "to"
    t.integer  "price"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "sauna_hall_schedules", ["sauna_hall_id"], :name => "index_sauna_hall_schedules_on_sauna_hall_id"

  create_table "sauna_halls", :force => true do |t|
    t.integer  "sauna_id"
    t.string   "title"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "tour_link"
    t.text     "vfs_path"
    t.text     "description"
  end

  add_index "sauna_halls", ["sauna_id"], :name => "index_sauna_halls_on_sauna_id"

  create_table "sauna_massages", :force => true do |t|
    t.integer  "sauna_id"
    t.integer  "classical"
    t.integer  "spa"
    t.integer  "anticelltilitis"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "sauna_massages", ["sauna_id"], :name => "index_sauna_massages_on_sauna_id"

  create_table "sauna_oils", :force => true do |t|
    t.integer  "sauna_id"
    t.integer  "ability"
    t.boolean  "sale"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sauna_oils", ["sauna_id"], :name => "index_sauna_oils_on_sauna_id"

  create_table "sauna_stuffs", :force => true do |t|
    t.integer  "sauna_id"
    t.integer  "wifi"
    t.integer  "safe"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sauna_stuffs", ["sauna_id"], :name => "index_sauna_stuffs_on_sauna_id"

  create_table "schedules", :force => true do |t|
    t.integer  "day"
    t.time     "from"
    t.time     "to"
    t.integer  "organization_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.boolean  "holiday"
  end

  create_table "services", :force => true do |t|
    t.text     "title"
    t.text     "feature"
    t.text     "age"
    t.string   "context_type"
    t.integer  "context_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.text     "category"
    t.text     "description"
  end

  create_table "showings", :force => true do |t|
    t.integer  "affiche_id"
    t.string   "place"
    t.datetime "starts_at"
    t.integer  "price_min"
    t.string   "hall"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.datetime "ends_at"
    t.integer  "price_max"
    t.integer  "organization_id"
    t.string   "latitude"
    t.string   "longitude"
  end

  add_index "showings", ["affiche_id"], :name => "index_showings_on_affiche_id"

  create_table "social_links", :force => true do |t|
    t.integer  "organization_id"
    t.text     "title"
    t.text     "url"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "social_links", ["organization_id"], :name => "index_social_links_on_organization_id"

  create_table "sports", :force => true do |t|
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "organization_id"
    t.string   "title"
    t.text     "description"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "oauth_key"
    t.integer  "roles_mask"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "uid"
  end

  add_index "users", ["oauth_key"], :name => "index_users_on_oauth_key", :unique => true

  create_table "works", :force => true do |t|
    t.text     "image_url"
    t.string   "author_info"
    t.integer  "contest_id"
    t.string   "title"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "slug"
    t.integer  "vk_likes"
  end

  add_index "works", ["contest_id"], :name => "index_works_on_contest_id"
  add_index "works", ["slug"], :name => "index_works_on_slug", :unique => true

end
