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

ActiveRecord::Schema.define(:version => 20130425071258) do

  create_table "activities", :force => true do |t|
    t.string   "activitable_type"
    t.integer  "activitable_id"
    t.integer  "user_id"
    t.datetime "date"
    t.string   "action"
    t.string   "description"
    t.integer  "kudos_points",     :default => 0
    t.datetime "created_at",                                        :null => false
    t.datetime "updated_at",                                        :null => false
    t.string   "sub_type"
    t.string   "icon_path",        :default => "default-image.png"
    t.datetime "deleted_at"
  end

  create_table "admins", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "admins", ["email"], :name => "index_admins_on_email", :unique => true
  add_index "admins", ["reset_password_token"], :name => "index_admins_on_reset_password_token", :unique => true

  create_table "advertises", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.text     "message"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "assistants", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "categories", :force => true do |t|
    t.string   "deal_site_category"
    t.string   "major_category"
    t.string   "minor_category"
    t.string   "description"
    t.string   "photo"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "deal_categories"
    t.datetime "deleted_at"
  end

  create_table "city_divisions", :force => true do |t|
    t.string   "primary_city"
    t.string   "state"
    t.string   "division"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "contacts", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.text     "message"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "deal_sites", :force => true do |t|
    t.string   "name"
    t.string   "deal_site_type"
    t.string   "url"
    t.string   "deal_site_params"
    t.string   "deal_site_key"
    t.boolean  "deal_site_status",  :default => false
    t.integer  "frequency"
    t.datetime "last_datetime_run"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
  end

  create_table "external_user_activities", :force => true do |t|
    t.integer  "user_id"
    t.string   "source"
    t.string   "ext_activity_type"
    t.text     "description"
    t.string   "location"
    t.integer  "location_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "friends", :force => true do |t|
    t.integer  "user_id"
    t.integer  "friend_id"
    t.datetime "deleted_at"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "friends_requests", :force => true do |t|
    t.integer  "friend_from_id"
    t.integer  "friend_to_id"
    t.string   "friend_from_message"
    t.string   "state"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  create_table "goal_advices", :force => true do |t|
    t.string   "goal_type"
    t.text     "expert_advice_description"
    t.string   "expert_advice_url"
    t.string   "state"
    t.datetime "deleted_at"
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
    t.string   "keywords"
    t.boolean  "snapgadget_expert",         :default => false
  end

  create_table "goals", :force => true do |t|
    t.string   "goal_type"
    t.text     "description"
    t.datetime "started_date"
    t.datetime "end_date"
    t.datetime "ended_date"
    t.integer  "completed",         :limit => 1, :default => 0
    t.integer  "status_percentage", :limit => 3, :default => 0
    t.integer  "user_id"
    t.string   "feeds"
    t.datetime "deleted_at"
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
    t.integer  "kudos_points"
    t.text     "notes"
  end

  create_table "groupon_external_categories", :force => true do |t|
    t.string   "groupon_category_id"
    t.integer  "snapgadget_category_id"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
  end

  create_table "insider_activities", :force => true do |t|
    t.integer  "user_id"
    t.integer  "offer_id"
    t.string   "activity_type"
    t.datetime "presented"
    t.integer  "no_of_times_presented", :default => 0
    t.datetime "snapped"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
  end

  create_table "insiders", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "languages", :force => true do |t|
    t.string   "description"
    t.string   "language_sid"
    t.datetime "deleted_at"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "spanishname"
  end

  create_table "living_social_external_categories", :force => true do |t|
    t.string   "living_social_category_id"
    t.integer  "snapgadget_category_id"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "location_linked_loc_lists", :force => true do |t|
    t.integer  "location_id"
    t.integer  "location_list_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.datetime "deleted_at"
  end

  create_table "location_lists", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "loc_list_type"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.integer  "original_share_id"
  end

  create_table "locations", :force => true do |t|
    t.string   "WOEID"
    t.string   "google_maps_cid"
    t.string   "foursquare_venue_id"
    t.string   "yelp_id"
    t.string   "latitude"
    t.string   "longitude"
    t.string   "name"
    t.string   "full_address"
    t.string   "phone"
    t.string   "sg_minor_category"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.string   "zip_code"
    t.integer  "user_id"
    t.string   "sg_location_name"
    t.integer  "kudos_points"
    t.string   "url"
    t.string   "state",               :default => "active"
    t.string   "street_address"
    t.string   "city"
    t.string   "location_state"
    t.string   "sg_major_category"
  end

  create_table "major_categories", :force => true do |t|
    t.string   "major_category_name"
    t.string   "english_version"
    t.string   "spanish_version"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.integer  "display_order"
  end

  create_table "master_keywords", :force => true do |t|
    t.string   "keyword"
    t.integer  "goal_advice_id"
    t.string   "category"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "membership_status_emails", :force => true do |t|
    t.string   "email"
    t.string   "membership_status"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "offer_merchant_ratings", :force => true do |t|
    t.string   "merchant_rating_site"
    t.string   "merchant_rating_score"
    t.string   "merchant_rating_reviews"
    t.integer  "offer_id"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  create_table "offer_options", :force => true do |t|
    t.integer  "number_sold"
    t.string   "value_currency"
    t.string   "value_amount"
    t.string   "price_currency"
    t.string   "price_amount"
    t.string   "discount_currency"
    t.string   "discount_amount"
    t.string   "discount_percent"
    t.float    "trend_score"
    t.integer  "offer_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "offer_redemption_locations", :force => true do |t|
    t.string   "redemption_neighborhood"
    t.string   "redemption_country"
    t.string   "redemption_street_address1"
    t.string   "redemption_street_address2"
    t.string   "redemption_city"
    t.string   "redemption_state"
    t.string   "redemption_zip_code"
    t.string   "redemption_lat"
    t.string   "redemption_lng"
    t.string   "redemption_phone_number"
    t.string   "woeid"
    t.integer  "offer_id"
    t.integer  "offer_option_id"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  create_table "offer_zip_deals", :force => true do |t|
    t.string   "zipcode"
    t.string   "latitude"
    t.string   "longitude"
    t.string   "groupon_division"
    t.string   "livingsocial_division"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
  end

  create_table "offers", :force => true do |t|
    t.string   "deal_source"
    t.string   "deal_id"
    t.string   "merchant_name"
    t.string   "category_id"
    t.string   "deal_type"
    t.string   "merchant_type"
    t.boolean  "national_deal"
    t.boolean  "local_deal"
    t.string   "division_id"
    t.decimal  "division_lat",             :precision => 12, :scale => 8
    t.decimal  "division_lng",             :precision => 12, :scale => 8
    t.string   "large_image_url"
    t.string   "small_image_url"
    t.string   "status"
    t.string   "deal_url"
    t.string   "deal_header"
    t.datetime "deal_start"
    t.datetime "deal_updated"
    t.datetime "deal_end"
    t.boolean  "deal_tipped"
    t.datetime "deal_tipped_at"
    t.datetime "created_at",                                                             :null => false
    t.datetime "updated_at",                                                             :null => false
    t.string   "redemption_location"
    t.integer  "snapgadget_category_id"
    t.string   "short_announcement_title"
    t.integer  "score",                                                   :default => 0
    t.float    "trend_score"
  end

  create_table "passionates", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.integer  "snapgadget_category_id"
    t.integer  "location_id"
    t.text     "passionate_text"
    t.string   "url"
    t.integer  "kudos_points",           :default => 0, :null => false
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.datetime "deleted_at"
  end

  create_table "photos", :force => true do |t|
    t.string   "image"
    t.datetime "deleted_at"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "imageable_id"
    t.string   "imageable_type"
    t.string   "old_image"
  end

  create_table "preference_questions", :force => true do |t|
    t.string   "title"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "reviewer_of_the_days", :force => true do |t|
    t.string   "zip_code"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "reviews", :force => true do |t|
    t.integer  "user_id"
    t.integer  "location_id"
    t.boolean  "review_status"
    t.integer  "review_been_seen"
    t.integer  "review_approvals"
    t.float    "user_quick_star"
    t.boolean  "allow_personal_offers"
    t.text     "review_details"
    t.integer  "kudos_points"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id"
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "sg_pages", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "shares", :force => true do |t|
    t.integer  "user_id"
    t.string   "shareable_type"
    t.string   "shareable_id"
    t.text     "comment"
    t.string   "status"
    t.datetime "deleted_at"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "sidekicks", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "social_media", :force => true do |t|
    t.string   "name"
    t.integer  "social_media_id"
    t.datetime "deleted_at"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "social_media_xrefs", :force => true do |t|
    t.string   "social_media_source"
    t.string   "source_media_keywords"
    t.datetime "deleted_at"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
  end

  create_table "suggestions", :force => true do |t|
    t.string   "name"
    t.datetime "when"
    t.integer  "snapgadget_category_id"
    t.integer  "location_id"
    t.integer  "user_id"
    t.text     "comments"
    t.string   "url"
    t.integer  "kudos_points"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
  end

  create_table "trackers", :force => true do |t|
    t.string   "trackable_type"
    t.integer  "trackable_id"
    t.integer  "user_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.datetime "deleted_at"
    t.integer  "shared_from_id"
  end

  create_table "user_linked_withs", :force => true do |t|
    t.integer  "user_id"
    t.integer  "social_media_id"
    t.datetime "deleted_at"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "user_preferences", :force => true do |t|
    t.integer  "user_id"
    t.integer  "landing_page_id"
    t.integer  "offer_category_1"
    t.integer  "offer_category_2"
    t.integer  "offer_category_3"
    t.integer  "suggestion_category_1"
    t.integer  "suggestion_category_2"
    t.integer  "suggestion_category_3"
    t.integer  "you_deserve_it_category"
    t.boolean  "repeat_experiences"
    t.boolean  "lifestyle_on_sidekick"
    t.boolean  "shopping_on_sidekick"
    t.boolean  "food_on_sidekick"
    t.boolean  "business_on_sidekick"
    t.boolean  "friends_on_sidekick"
    t.string   "question_1"
    t.string   "question_2"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
    t.boolean  "travel_on_sidekick"
    t.string   "question_3"
    t.string   "question_4"
    t.string   "question_5"
  end

  create_table "user_profiles", :force => true do |t|
    t.integer  "user_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "gender"
    t.string   "description"
    t.string   "picture"
    t.integer  "language_id"
    t.string   "relationship_status"
    t.string   "locale"
    t.string   "timezone"
    t.string   "address"
    t.string   "street"
    t.string   "location_name"
    t.string   "zip"
    t.string   "country"
    t.datetime "date_of_birth"
    t.string   "education"
    t.string   "interests"
    t.integer  "followers_count"
    t.integer  "friends_count"
    t.integer  "user_status_id"
    t.datetime "deleted_at"
    t.datetime "created_at",                                                          :null => false
    t.datetime "updated_at",                                                          :null => false
    t.integer  "offer_category_1"
    t.integer  "offer_category_2"
    t.integer  "offer_category_3"
    t.integer  "suggestion_category_1"
    t.integer  "suggestion_category_2"
    t.integer  "suggestion_category_3"
    t.integer  "you_deserve_it_category"
    t.boolean  "repeat_experiences",      :default => true
    t.boolean  "lifestyle_on_sidekick",   :default => false
    t.boolean  "shopping_on_sidekick",    :default => false
    t.boolean  "food_on_sidekick",        :default => false
    t.boolean  "business_on_sidekick",    :default => false
    t.boolean  "travel_on_sidekick",      :default => false
    t.boolean  "friends_on_sidekick",     :default => false
    t.string   "question_1"
    t.string   "question_2"
    t.string   "question_3"
    t.string   "question_4"
    t.string   "question_5"
    t.integer  "landing_page_id"
    t.string   "woe_id"
    t.string   "location_street"
    t.string   "location_city"
    t.string   "location_state"
    t.string   "location_zipcode"
    t.string   "insider_icon_img",        :default => "insider_male_d6c4c2_ffd8b6"
    t.string   "sidekick_icon_img",       :default => "sidekick_male_d6c4c2_ffd8b6"
    t.string   "assistant_icon_img",      :default => "assistant_male_d6c4c2_ffd8b6"
    t.boolean  "show_sidekick_guide",     :default => true
    t.boolean  "show_insider_guide",      :default => true
    t.boolean  "show_assistant_guide",    :default => true
    t.boolean  "show_dashboard_guide",    :default => true
  end

  create_table "user_questions", :force => true do |t|
    t.integer  "user_id"
    t.string   "question_1"
    t.string   "question_2"
    t.string   "question_3"
    t.string   "question_4"
    t.string   "question_5"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "",                    :null => false
    t.string   "encrypted_password",     :default => "",                    :null => false
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
    t.string   "unconfirmed_email"
    t.string   "authentication_token"
    t.string   "id_str"
    t.string   "source"
    t.string   "source_id"
    t.string   "name"
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "deleted_at"
    t.datetime "created_at",                                                :null => false
    t.datetime "updated_at",                                                :null => false
    t.string   "membership_type"
    t.string   "reviewer_status"
    t.integer  "kudos_points",           :default => 0
    t.string   "ambasador_status"
    t.string   "slug"
    t.datetime "lda",                    :default => '2013-02-27 17:33:55'
    t.integer  "influence_meter_score",  :default => 1
  end

  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["slug"], :name => "index_users_on_slug", :unique => true

  create_table "zip_lat_lngs", :force => true do |t|
    t.string   "zipcode"
    t.string   "primary_city"
    t.string   "state"
    t.string   "latitude"
    t.string   "longitude"
    t.string   "division"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "ls_division"
  end

end
