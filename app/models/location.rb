class Location < ActiveRecord::Base
  include KudosPoints
  
  attr_accessible :WOEID, :google_maps_cid, :foursquare_venue_id, :yelp_id,
    :latitude, :longitude, :name, :full_address, :phone, :sg_major_category, :sg_minor_category,
    :street_address, :city, :location_state, :review, :review_attributes, :zip_code

  module Kudos_Pts
    Create_Location = 1
  end
  
  attr_accessor :kudos_score, :location_pics
  
  default_scope where(:state => 'active')

  before_destroy :mark_personal_offer_false

  belongs_to :user

  state_machine :initial => :active do

    event :archive do
      transition :active => :archive
    end

    event :loc_delete do
      transition :archive => :loc_delete
    end

  end

  has_many :location_linked_loc_lists, :dependent => :destroy
  has_many :location_lists, :through => :location_linked_loc_lists
  has_many :shares, :as => :shareable, :dependent => :destroy
  has_many :trackers, :as => :trackable, :dependent => :destroy
  has_many :suggestions, :dependent => :destroy

  has_one :activity, :as => :activitable
  has_one :review
  accepts_nested_attributes_for :review, :allow_destroy => true

  has_one :passionate, :dependent => :destroy

  scope :search, proc{|term| where("name like '%#{term}%' OR full_address like '%#{term}%'")}
  
  validates :name, :presence => true

  #after_validation :geocode, :if => :name_changed?
  #after_validation :reverse_geocode

  after_initialize :set_kudos_score, :initialize_location_array
  #after_validation :update_kudos_points
  after_create :create_activity

  Dining = "dining"

  module Categories
    Lifestyle = "lifestyle"
    Shopping = "shopping"
    Food= "food"
    Travel = "travel"
    Business = "business"
    All = [Lifestyle, Shopping, Food, Travel, Business]
  end

  scope :around_locations, proc {|ne_lat, ne_lng, sw_lat, sw_lng| where('(latitude BETWEEN ? AND ? ) AND (longitude BETWEEN ? AND ?)', sw_lat.to_f, ne_lat.to_f, sw_lng.to_f, ne_lng.to_f ) }
  scope :food_locations, where("sg_major_category like '%#{Location::Categories::Food}%' OR sg_major_category = ?", Dining)
  scope :shopping_locations, where("sg_major_category like '%#{Location::Categories::Shopping}%'")
  scope :lifestyle_locations, where("sg_major_category like '%#{Location::Categories::Lifestyle}%'")
  scope :business_locations, where("sg_major_category like '%#{Location::Categories::Business}%'" )
  scope :travel_locations, where("sg_major_category like '%#{Location::Categories::Travel}%'" )
  scope :my_friends_locations, proc {|user| where("locations.id IN (SELECT location_id FROM reviews WHERE locations.id = reviews.location_id AND reviews.user_id IN (?)) OR (locations.user_id IN (?))", user.friends.map(&:friend_id) + [user.id], user.friends.map(&:friend_id) + [user.id] )}
  scope :my_locations, proc {|user| where("locations.id IN (SELECT location_id FROM reviews WHERE locations.id = reviews.location_id AND reviews.user_id IN (?)) OR (locations.user_id IN (?))",[user.id], [user.id] )}
  scope :my_or_friends_locations, proc {|users_id| where("locations.id IN (SELECT location_id FROM reviews WHERE locations.id = reviews.location_id AND reviews.user_id IN (?)) OR (locations.user_id IN (?))", users_id, users_id)}
  scope :locations_with_woeid_and_name, proc {|location| where("WOEID = ? AND name like ?", location.WOEID, location.name)}

  def set_kudos_score
    @kudos_score = Location::Kudos_Pts::Create_Location
  end

  def initialize_location_array
    @location_pics = []
  end

  def description
    self.name.present? ? ("#{self.name}"):('')
  end

  def action
    I18n.t(:added)
  end

  def icon_path(user_profile)
    "/assets/advisor_icons/sidekick/#{user_profile.present? ? (user_profile.sidekick_icon_img):("sidekick_male_d6c4c2_ffd8b6")}.png"
  end

  def owner_or_not(user)
    user.locations.include?(self) ? ("yes") : ("no")
  end

  def is
    SG::SIDEKICK
  end

  def get_toogle_icon_id
    case sg_major_category
    when /business/i
      'business'
    when /food/i
      'food'
    when /lifestyle/i
      'lifestyle'
    when /shopping/i
      'shopping'
    when /travel/i
      'travel'
    when /dining/i
      'food'
    end
  end

  def location_images(current_user, type=nil)
    my_passionate_photos = Photo.my_passionate_photo(Passionate.to_s, self, current_user)
    my_suggestion_photos = Photo.my_suggestion_photo(Suggestion.to_s, self, current_user)
    
    if type == Passionate.to_s
      if my_passionate_photos.present?
        @location_pics +=  my_passionate_photos
        return if @location_pics.count >=3
      end
      
      if my_suggestion_photos.present?
        @location_pics += my_suggestion_photos
        return if @location_pics.count >=3
      end
      remaining_photo_options_for_grid(current_user)

    else
      if my_suggestion_photos.present?
        @location_pics += my_suggestion_photos
        return if @location_pics.count >=3
      end
      if my_passionate_photos.present?
        @location_pics += my_passionate_photos
        return if @location_pics.count >=3
      end
      remaining_photo_options_for_grid(current_user)
    end
    
  end
  
  def default_image(current_user, type = nil)
    my_passionate_photo = Photo.my_passionate_photo(Passionate.to_s, self, current_user).first
    my_suggestion_photo = Photo.my_suggestion_photo(Suggestion.to_s, self, current_user).first
      
    if type == Passionate.to_s
      if my_passionate_photo.present?
        my_passionate_photo.image_url(:standard_image)
      elsif my_suggestion_photo.present?
        my_suggestion_photo.image_url(:suggestion_image)
      else
        remaining_photo_options(current_user)
      end
      
    else
      if my_suggestion_photo.present?
        my_suggestion_photo.image_url(:suggestion_image)
      elsif my_passionate_photo.present?
        my_passionate_photo.image_url(:standard_image)
      else
        remaining_photo_options(current_user)
      end
    end
  end

  def remaining_photo_options(current_user)
    my_review_photo = Photo.my_review_photo(Review.to_s, self, current_user).first
    friend_passionate_photo = Photo.friend_passionate_photo(Passionate.to_s, self, current_user).first
    friend_suggestion_photo = Photo.friend_suggestion_photo(Suggestion.to_s, self, current_user).first
    friend_review_photo = Photo.friend_review_photo(Review.to_s, self, current_user).first

    other_passionate_photo = Photo.other_passionate_photo(Passionate.to_s, self, current_user).first
    other_suggestion_photo = Photo.other_suggestion_photo(Suggestion.to_s, self, current_user).first
    other_review_photo = Photo.other_review_photo(Review.to_s, self, current_user).first

    if my_review_photo.present?
      my_review_photo.image_url(:standard_image)
    elsif friend_passionate_photo.present?
      friend_passionate_photo.image_url(:standard_image)
    elsif friend_suggestion_photo.present?
      friend_suggestion_photo.image_url(:suggestion_image)
    elsif friend_review_photo.present?
      friend_review_photo.image_url(:standard_image)

    elsif other_passionate_photo.present?
      other_passionate_photo.image_url(:standard_image)
    elsif other_suggestion_photo.present?
      other_suggestion_photo.image_url(:suggestion_image)
    elsif other_review_photo.present?
      other_review_photo.image_url(:standard_image)
    else
      nil
    end
  end

  def remaining_photo_options_for_grid(current_user)
    my_review_photos = Photo.my_review_photo(Review.to_s, self, current_user)
    friend_passionate_photos = Photo.friend_passionate_photo(Passionate.to_s, self, current_user)
    friend_suggestion_photos = Photo.friend_suggestion_photo(Suggestion.to_s, self, current_user)
    friend_review_photos = Photo.friend_review_photo(Review.to_s, self, current_user)

    other_passionate_photos = Photo.other_passionate_photo(Passionate.to_s, self, current_user)
    other_suggestion_photos = Photo.other_suggestion_photo(Suggestion.to_s, self, current_user)
    other_review_photos = Photo.other_review_photo(Review.to_s, self, current_user)

    if my_review_photos.present?
      @location_pics += my_review_photos
      return if @location_pics.count >=3
    end

    if friend_passionate_photos.present?
      @location_pics += friend_passionate_photos
      return if @location_pics.count >=3
    end
    
    if friend_suggestion_photos.present?
      @location_pics += friend_suggestion_photos
      return if @location_pics.count >=3
    end
    
    if friend_review_photos.present?
      @location_pics += friend_review_photos
      return if @location_pics.count >=3
    end

    if other_passionate_photos.present?
      @location_pics += friend_passionate_photos
      return if @location_pics.count >=3
    end
    
    if other_suggestion_photos.present?
      @location_pics += friend_suggestion_photos
      return if @location_pics.count >=3
    end

    if other_review_photos.present?
      @location_pics += friend_review_photos
      return if @location_pics.count >=3
    end
    
  end
    
  def get_suggestion(suggestion_ids)
    if suggestion_ids.include?(self.id)
      suggestion = Suggestion.where("location_id = ?", self.id).first
      suggestion.id
    else
      0
    end
  end

  def delete_location
    self.destroy
  end

  def mark_personal_offer_false
    self.review.present? ? (self.review.update_attributes(:allow_personal_offers => false)) : ()
  end

  def friend_passionate current_user
    passionate.present?
  end

  def custom_name current_user
    passionate.present? ? ("#{name} - #{user.full_name}") : (name)
  end


  def is_passionate_and_suggestion_location?(suggestion_locations, current_user)
    suggestion_locations.include?(self.id) && current_user.passionate && current_user.passionate.location.id == self.id
  end

  def is_suggestion_location?(suggestion_locations)
    suggestion_locations.include?(self.id)
  end

  def clone_location(current_user)
    new_location = self.dup
    new_location.user_id = current_user.id
    new_location
  end

  class << self
    def check_for_location(location, current_user)
      woeid = location[:WOEID].presence || location[:woe_id]
      if location[:name] && (location[:WOEID].presence || location[:woe_id])
        locs = where("WOEID = ? AND user_id = ? ", woeid, current_user.id)
        if locs.present?
          street_address = location[:street_address].present? ? (location[:street_address].gsub("'","\'").strip) : ("-9999")
          location_name = location[:name].present? ? (location[:name].gsub("'", "\'").strip) : ("-9999")
          loc = locs.where("street_address like ? OR name like ?", street_address, location_name).first
        end
      end
      loc
    end

    def check_for_location_created_by_others(location, current_user)
      woeid = location[:WOEID].presence || location[:woe_id]
      if location[:name] && (location[:WOEID].presence || location[:woe_id])
        locs = where("WOEID = ? AND user_id NOT IN(?)", woeid, current_user.id)
        if locs.present?
          street_address = location[:street_address].present? ? (location[:street_address].gsub("'","\'").strip) : ("-9999")
          location_name = location[:name].present? ? (location[:name].gsub("'", "\'").strip) : ("-9999")
          loc = locs.where("street_address like ? OR name like ?", street_address, location_name).first
        end
      end
      loc
    end

    
  end
end

