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

ActiveRecord::Schema.define(:version => 20130606085655) do

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
    t.string   "kind"
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
    t.string   "office"
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
    t.float    "age_min"
    t.float    "age_max"
    t.float    "total_rating"
    t.string   "state"
    t.string   "poster_image_file_name"
    t.string   "poster_image_content_type"
    t.integer  "poster_image_file_size"
    t.datetime "poster_image_updated_at"
    t.text     "poster_image_url"
    t.integer  "user_id"
  end

  add_index "affiches", ["slug"], :name => "index_affiches_on_slug", :unique => true
  add_index "affiches", ["user_id"], :name => "index_affiches_on_user_id"

  create_table "attachments", :force => true do |t|
    t.integer  "attachable_id"
    t.string   "attachable_type"
    t.text     "description"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "type"
    t.text     "thumbnail_url"
    t.integer  "height"
    t.integer  "width"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.text     "file_url"
  end

  create_table "car_sales_centers", :force => true do |t|
    t.text     "category"
    t.text     "description"
    t.text     "feature"
    t.string   "title"
    t.text     "offer"
    t.integer  "organization_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "car_sales_centers", ["organization_id"], :name => "index_car_sales_centers_on_organization_id"

  create_table "car_service_centers", :force => true do |t|
    t.text     "category"
    t.text     "description"
    t.text     "feature"
    t.string   "title"
    t.text     "offer"
    t.integer  "organization_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "car_service_centers", ["organization_id"], :name => "index_car_service_centers_on_organization_id"

  create_table "car_washes", :force => true do |t|
    t.text     "category"
    t.integer  "organization_id"
    t.string   "title"
    t.text     "description"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.text     "offer"
    t.text     "feature"
  end

  add_index "car_washes", ["organization_id"], :name => "index_car_washes_on_organization_id"

  create_table "comments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.text     "body"
    t.string   "ancestry"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "comments", ["commentable_id"], :name => "index_comments_on_commentable_id"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

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

  create_table "copies", :force => true do |t|
    t.string   "state"
    t.string   "code"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "copy_payment_id"
    t.integer  "copyable_id"
    t.string   "copyable_type"
    t.integer  "row"
    t.integer  "seat"
  end

  add_index "copies", ["copy_payment_id"], :name => "index_tickets_on_payment_id"
  add_index "copies", ["copyable_id"], :name => "index_copies_on_copyable_id"
  add_index "copies", ["copyable_type"], :name => "index_copies_on_copyable_type"

  create_table "coupons", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "discount"
    t.string   "vfs_path"
    t.integer  "organization_id"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.text     "image_url"
    t.integer  "price_with_discount"
    t.integer  "price_without_discount"
    t.integer  "organization_quota"
    t.integer  "price"
    t.string   "kind"
    t.string   "place"
    t.integer  "number"
    t.datetime "stale_at"
    t.datetime "complete_at"
    t.text     "categories"
    t.text     "affiliate_url"
  end

  add_index "coupons", ["organization_id"], :name => "index_coupons_on_organization_id"

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

  create_table "hotels", :force => true do |t|
    t.text     "category"
    t.text     "description"
    t.text     "feature"
    t.string   "title"
    t.text     "offer"
    t.integer  "organization_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "hotels", ["organization_id"], :name => "index_hotels_on_organization_id"

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

  create_table "menu_positions", :force => true do |t|
    t.integer  "menu_id"
    t.string   "position"
    t.string   "title"
    t.text     "description"
    t.string   "price"
    t.string   "count"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.integer  "cooking_time"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.text     "image_url"
  end

  add_index "menu_positions", ["menu_id"], :name => "index_menu_positions_on_menu_id"

  create_table "menus", :force => true do |t|
    t.integer  "meal_id"
    t.string   "category"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "menus", ["meal_id"], :name => "index_menus_on_meal_id"

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
    t.datetime "created_at",                                      :null => false
    t.datetime "updated_at",                                      :null => false
    t.text     "phone"
    t.string   "vfs_path"
    t.integer  "organization_id"
    t.text     "logotype_url"
    t.string   "slug"
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
    t.float    "total_rating"
    t.integer  "primary_organization_id"
    t.boolean  "ability_to_comment",            :default => true
    t.string   "phone_for_sms"
    t.float    "balance"
  end

  add_index "organizations", ["slug"], :name => "index_organizations_on_slug", :unique => true
  add_index "organizations", ["user_id"], :name => "index_organizations_on_user_id"

  create_table "paperclip_attachments", :force => true do |t|
    t.integer  "attacheable_id"
    t.string   "attacheable_type"
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.text     "attachment_url"
    t.string   "attachment_type"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  add_index "paperclip_attachments", ["attacheable_id", "attacheable_type"], :name => "index_paperclip_attachments_on_attacheable_fields"

  create_table "payments", :force => true do |t|
    t.integer  "paymentable_id"
    t.integer  "number"
    t.string   "phone"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "user_id"
    t.string   "paymentable_type"
    t.string   "type"
    t.float    "amount"
    t.text     "details"
    t.string   "state"
  end

  add_index "payments", ["paymentable_id"], :name => "index_payments_on_paymentable_id"
  add_index "payments", ["paymentable_type"], :name => "index_payments_on_paymentable_type"
  add_index "payments", ["type"], :name => "index_payments_on_type"
  add_index "payments", ["user_id"], :name => "index_payments_on_user_id"

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

  create_table "prices", :force => true do |t|
    t.string   "kind"
    t.integer  "value"
    t.integer  "count"
    t.string   "period"
    t.integer  "service_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "description"
    t.integer  "max_value"
  end

  add_index "prices", ["service_id"], :name => "index_prices_on_service_id"

  create_table "roles", :force => true do |t|
    t.integer  "user_id"
    t.string   "role"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "roles", ["user_id"], :name => "index_roles_on_user_id"

  create_table "salon_centers", :force => true do |t|
    t.text     "category"
    t.text     "description"
    t.text     "feature"
    t.string   "title"
    t.text     "offer"
    t.integer  "organization_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "salon_centers", ["organization_id"], :name => "index_salon_centers_on_organization_id"

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

  create_table "saunas", :force => true do |t|
    t.text     "category"
    t.text     "feature"
    t.text     "offer"
    t.string   "payment"
    t.integer  "organization_id"
    t.string   "title"
    t.text     "description"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

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
    t.text     "offer"
    t.string   "kind"
    t.integer  "min_value"
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

  create_table "sms_claims", :force => true do |t|
    t.string   "name"
    t.string   "phone"
    t.text     "details"
    t.integer  "claimed_id"
    t.string   "claimed_type"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "smses", :force => true do |t|
    t.string   "phone"
    t.string   "status"
    t.integer  "smsable_id"
    t.string   "smsable_type"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.text     "message"
  end

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

  create_table "tickets", :force => true do |t|
    t.integer  "affiche_id"
    t.integer  "number"
    t.float    "original_price"
    t.float    "price"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.text     "description"
    t.datetime "stale_at"
    t.float    "organization_price"
  end

  add_index "tickets", ["affiche_id"], :name => "index_ticket_infos_on_affiche_id"

  create_table "travels", :force => true do |t|
    t.text     "category"
    t.text     "description"
    t.text     "feature"
    t.string   "title"
    t.text     "offer"
    t.integer  "organization_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "travels", ["organization_id"], :name => "index_travels_on_organization_id"

  create_table "user_ratings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "rateable_id"
    t.string   "rateable_type"
    t.integer  "value"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "user_ratings", ["rateable_id", "rateable_type"], :name => "index_user_ratings_on_rateable_id_and_rateable_type"
  add_index "user_ratings", ["user_id"], :name => "index_user_ratings_on_user_id"

  create_table "users", :force => true do |t|
    t.integer  "roles_mask"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "uid"
    t.integer  "sign_in_count",       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "provider"
    t.text     "auth_raw_info"
    t.datetime "remember_created_at"
    t.string   "remember_token"
  end

  create_table "virtual_tours", :force => true do |t|
    t.string   "link"
    t.integer  "tourable_id"
    t.string   "tourable_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "virtual_tours", ["tourable_id", "tourable_type"], :name => "index_virtual_tours_on_tourable_id_and_tourable_type"

  create_table "visits", :force => true do |t|
    t.integer  "user_id"
    t.integer  "visitable_id"
    t.string   "visitable_type"
    t.boolean  "visited"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "visits", ["user_id"], :name => "index_visits_on_user_id"
  add_index "visits", ["visitable_id"], :name => "index_visits_on_visitable_id"

  create_table "votes", :force => true do |t|
    t.integer  "user_id"
    t.boolean  "like",          :default => false
    t.integer  "voteable_id"
    t.string   "voteable_type"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  add_index "votes", ["user_id"], :name => "index_votes_on_user_id"
  add_index "votes", ["voteable_id"], :name => "index_votes_on_voteable_id"

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
