class Suggestion < ActiveRecord::Base
  include KudosPoints

  module Kudos_Pts
    Create_Suggestion = 5
    Share_Suggestion = 2
  end

  attr_accessor :kudos_score
  attr_accessible :name, :snapgadget_category_id, :location_id, :user_id, :comments, :when,
    :url, :kudos_points, :photos_attributes

  belongs_to :user
  belongs_to :location
  has_many :photos, :as => :imageable, :dependent => :destroy
  accepts_nested_attributes_for :photos, :allow_destroy => true
  has_one :activity, :as => :activitable

  has_many :shares, :as => :shareable, :dependent => :destroy
  has_many :trackers, :as => :trackable, :dependent => :destroy

  after_initialize :set_kudos_score
  after_create :create_activity
  
  validates :name, :presence => true
  validates_datetime :when

  scope :category_matching_suggestions, proc {|category_ids| where("snapgadget_category_id IN(?)", category_ids)}
  scope :sg_category_1_suggestions, proc {|user_profile| where("snapgadget_category_id IN(?)", user_profile.suggestion_category_1)}
  scope :sg_category_2_suggestions, proc {|user_profile| where("snapgadget_category_id = ? ", user_profile.suggestion_category_2)}
  scope :sg_category_3_suggestions, proc {|user_profile| where("snapgadget_category_id = ? ", user_profile.suggestion_category_3)}
  scope :city_matching_suggestions, proc{|current_user| joins(:location).where("locations.city = ? ", current_user.user_profile.location_city)}
  scope :state_matching_suggestions, proc{|current_user| joins(:location).where("locations.location_state = ? ", current_user.user_profile.location_state)}
  scope :friends_city_based_suggestions, proc {|current_user| where("user_id IN (?) AND location_id IN(SELECT id FROM locations WHERE suggestions.location_id = locations.id AND locations.city = ?)", current_user.friends.map(&:friend_id), current_user.user_profile.location_city).order('suggestions.when ASC')}
  scope :friends_state_based_suggestions, proc {|current_user| where("user_id IN (?) AND location_id IN(SELECT id FROM locations WHERE suggestions.location_id = locations.id AND locations.location_state = ?)", current_user.friends.map(&:friend_id), current_user.user_profile.location_state).order('suggestions.when ASC')}
  scope :exclude_friends_suggestions, proc {|current_user| where("suggestions.user_id NOT IN(?)", current_user.friends.map(&:friend_id).presence || [-9999])}
  scope :my_friends_suggestions, proc {|location, current_user| where("location_id IN(?) AND user_id IN(?)", Location.locations_with_woeid_and_name(location).map(&:id), current_user.friends.map(&:friend_id)).order('created_at ASC')}
  scope :other_suggestions, proc {|location, current_user| where("location_id IN(?) AND user_id NOT IN(?)", Location.locations_with_woeid_and_name(location).map(&:id), ([current_user.id] + current_user.friends.map(&:friend_id)).presence || [-9999]).order('created_at ASC')}
  scope :shared_to_me, proc {|current_user| where("id IN(SELECT shareable_id from shares WHERE (SELECT trackable_id FROM trackers WHERE shares.shareable_id = trackers.trackable_id AND shares.shareable_type = ? AND trackers.trackable_type = ? AND trackers.user_id = ? ))", Suggestion.to_s, Suggestion.to_s, current_user.id)}

  def set_kudos_score
    @kudos_score = Suggestion::Kudos_Pts::Create_Suggestion
  end
  
  def icon_path(user_profile)
    "/assets/advisor_icons/insider/#{user_profile.present? ? (user_profile.insider_icon_img) : ("insider_male_d6c4c2_ffd8b6")}.png"
  end

  def action
    "Added"
  end

  def description
    "Suggestion - #{name}"
  end

  def customized_url
    if url =~ /^http:\/\//i
      url
    elsif url =~ /^https:\/\//i
      url
    else
      "http://" + url
    end
  end

  def share_description
    "Suggestion - #{name}"
  end

  def share_action
    "Shared"
  end

  def set_share_score
    Suggestion::Kudos_Pts::Share_Suggestion
  end
  
  class << self
    
    def city_or_state_matching_suggestions(suggestions, current_user)
      suggestions.city_matching_suggestions(current_user).presence || suggestions.state_matching_suggestions(current_user)
    end

    def all_except_friends_suggestions(current_user)
      user_profile = current_user.user_profile
      category_ids = Category.user_suggestion_categories(user_profile)
      suggestions = Suggestion.category_matching_suggestions(category_ids)
      own_suggestions = city_or_state_matching_suggestions(suggestions, current_user)
      own_suggestions.exclude_friends_suggestions(current_user).order('suggestions.when ASC') 
    end
    
    def friends_suggestions(current_user)
      Suggestion.friends_city_based_suggestions(current_user).present? ? (Suggestion.friends_city_based_suggestions(current_user)) : (Suggestion.friends_state_based_suggestions(current_user))
    end

  end

end

