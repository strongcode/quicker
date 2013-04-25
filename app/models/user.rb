class User < ActiveRecord::Base
  include KudosPoints
  extend OmniauthCallbacks
  extend FriendlyId

  module Kudos_Pts
    Create_Account = 50
    Sign_in = 1
  end

  module Influence_Meter_Score
    Standard = 1
    Co_Founder = 99
    Social_Pioneer = 10
    Elite = 10
  end
  
  module Membership_Types
    Standard = "standard"
    Co_Founder = "co-founder"
    Social_Pioneer = "social pioneer"
    Elite = "elite"
  end

  friendly_id :custom_slug, :use => :slugged

  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable, :omniauthable, :token_authenticatable, :trackable

  attr_accessible :email, :password, :password_confirmation, :remember_me, :source, :source_id,
    :name, :first_name, :last_name, :gender, :locale, :picture, :photo_attributes, 
    :membership_type, :reviewer_status, :kudos_points, :ambasador_status,:terms_of_service,
    :pioneer_code

  attr_accessor :sg_remember_me, :kudos_score, :pioneer_code, :pioneer_flag
  after_initialize :set_kudos_score, :set_pioneer_flag

  #has_one :user_language, :dependent => :destroy
  has_one :user_profile, :dependent => :destroy
  has_one :user_preference, :dependent => :destroy
  has_one :user_question, :dependent => :destroy
  has_one :passionate, :dependent => :destroy

  has_many :user_linked_withs, :dependent => :destroy
  has_many :social_medias, :through => :user_linked_withs
  has_many :location_lists, :dependent => :destroy
  has_many :reviews, :dependent => :destroy
  has_many :goals, :dependent => :destroy
  has_many :friends, :dependent => :destroy
  has_many :reviewer_of_the_days, :dependent => :destroy
  has_many :friend_requests, :class_name => FriendsRequest, :dependent => :destroy, :foreign_key => :friend_to_id, :conditions => proc { "state = 'unread'"}
  has_many :friend_requests_sent, :dependent => :destroy, 
    :class_name => FriendsRequest, :foreign_key => :friend_from_id,
    :conditions => proc { "state = 'unread'"}
  has_many :locations
  has_many :trackers, :dependent => :destroy
  has_many :shares, :dependent => :destroy
  has_many :suggestions, :dependent => :destroy
  has_many :insider_activities, :dependent => :destroy
  has_many :activities
  
         
  has_many :trackings, :dependent => :destroy, :class_name => Tracker, :foreign_key => :shared_from_id

  validates :email,
    :format => {:with => /^(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})$/i,
    :message => 'Please enter valid email ID',
    :if => proc { |user| user.email.present? }
  }

  validates :pioneer_code,
    :format => {:with => /^rJVrcLfu3EkV$/,
    :message => ' does not match',
    :if => proc {|user| user.pioneer_code.present?}
  }
  
  validates :first_name, :last_name, :presence => true
  validates :first_name, :last_name, :length => {:minimum => 1, :maximum => 30}
  validates :pioneer_code, :presence => true, :if => :pioneer_flag_set?
  validates :email, :uniqueness => true, :if => proc { |user| user.email.present? }

  attr_accessor :terms_of_service

  before_validation :capitalize_name
  #validates_associated :user_profile

  before_save :ensure_authentication_token
  before_create :set_membership_type
  after_create :create_user_activity

  scope :non_friends, proc {|user, term, request_ids| where("id NOT IN(?) AND (first_name like '%#{term}%' OR last_name like '%#{term}%')", user.friends.map(&:friend_id) + request_ids + [user.id])}
  scope :friends_requests_made, proc {|user| where("id IN(SELECT friend_from_id FROM friends_requests WHERE users.id = friends_requests.friend_from_id AND friends_requests.friend_from_id = ? )", user.id )}
  
  def set_pioneer_flag
    @pioneer_flag = 0
  end

  def pioneer_flag_set?
    @pioneer_flag == 1
  end
  
  def set_kudos_score
    @kudos_score = User::Kudos_Pts::Create_Account
  end

  def offer_categories
    [user_profile.offer_category_1, user_profile.offer_category_2, user_profile.offer_category_3].uniq.compact
  end

  def suggestion_categories
    [user_profile.suggestion_category_1, user_profile.suggestion_category_2, user_profile.suggestion_category_3].uniq.compact
  end

  def set_membership_type
    self.membership_type ||= "Standard"
  end

  def custom_slug
    [first_name.presence, last_name.presence].compact.join(' ')
  end

  def description
    self.full_name.present? ? ("#{self.full_name}"):('')
  end

  def action
    "Signed Up"
  end

  def icon_path(user_profile)
    if user_profile.present? && user_profile.photo.present? && user_profile.photo.image.present?
      user_profile.photo.image_url(:standard_image)
    elsif user_profile.present? && user_profile.picture.present?
      user_profile.picture
    else
      "/assets/profile-images/blank-profile.png"
    end
  end

  def create_signin_activity
    user_profile = self.user_profile.present? ? (self.user_profile) : (self.build_user_profile)
    activity = self.activities.build
    activity.icon_path = user_profile.photo.present? &&  user_profile.photo.image.present? ? (user_profile.photo.image_url(:standard_image)):("/assets/profile-images/blank-profile.png")
    activity.update_my_activity(self, "Signed In", self.full_name, User::Kudos_Pts::Sign_in)
  end

  def develop_user_profile(user_profile)
    user_profile = build_user_profile(user_profile)
    user_profile.first_name = first_name
    user_profile.last_name = last_name
    user_profile.populate_locale
    user_profile.update_zipcode
    user_profile.save
  end

  def set_influence_meter_score
    self.influence_meter_score = 1
    case membership_type
    when User::Membership_Types::Co_Founder
      self.influence_meter_score = User::Influence_Meter_Score::Co_Founder
    when User::Membership_Types::Standard
      self.influence_meter_score = User::Influence_Meter_Score::Standard
    when User::Membership_Types::Social_Pioneer
      self.influence_meter_score = User::Influence_Meter_Score::Social_Pioneer
    when User::Membership_Types::Elite
      self.influence_meter_score = User::Influence_Meter_Score::Elite
    end
    
    unless membership_type.match(/#{User::Membership_Types::Co_Founder}/i)
      self.influence_meter_score += (reviews.count / 100) * 10
      self.influence_meter_score += (friends.count / 25) * 2
      self.influence_meter_score += (suggestions.count / 10) * 3
      
      if influence_meter_score > 95
        self.influence_meter_score = 95
      end
    end
    save
    influence_meter_score
  end

  def set_membership_status
    membership_email = MembershipStatusEmail.where("email = ? ", email).first
    self.membership_type = membership_email.present? ? (membership_email.membership_status.downcase) : (User::Membership_Types::Standard)
    save
  end

  def is_not_your_friend?(user)
    !get_friends.include?(user) && !friend_requests_sent.map(&:friend_to_id).include?(user.id)
  end

  def capitalize_name
    self.first_name = first_name.slice(0,1) + first_name.slice(1..-1) if first_name.present?
    self.last_name = last_name.slice(0,1) + last_name.slice(1..-1) if last_name.present?
  end

  def display_name
    "#{first_name} #{last_name}".squeeze(' ')
  end

  def first_name_with_last_name_initial
    "#{first_name} #{last_name.to_s[0].to_s.upcase}".squeeze(' ')
  end

  def full_name
    first_name.present? && last_name.present? ? ("#{(first_name.slice(0,1).capitalize + first_name.slice(1..-1))} #{last_name.first}.") :("")
  end

  def first
    first_name.present? ?  (first_name.slice(0,1).capitalize + first_name.slice(1..-1)):("")
  end

  def default_landing_page
    user_profile = self.user_profile
    if user_profile.present?
      Rails.application.routes.url_helpers.my_dashboard_path
    else
      Rails.application.routes.url_helpers.root_path
    end
  end

  def get_friends
    User.where("id IN (?)", self.friends.map(&:friend_id))
  end

  def non_shared_friends(trackable, trackable_type)
    trackers = Tracker.where("trackable_id = ? AND trackable_type = ? ", trackable.id, trackable_type)
    if trackers.count > friends.count
      friends_ids = trackers.map(&:user_id) - friends.map(&:friend_id)
    else
      friends_ids = friends.map(&:friend_id) - trackers.map(&:user_id)
    end
    User.where("id IN(?)", friends_ids)
  end
  
  def mini_avatar_image
    if self.user_profile.present? && self.user_profile.photo.present?
      self.user_profile.photo.image_url(:small_image)
    end
  end

  def my_passionate_location?(location)
    return false if self.passionate.blank?
    self.passionate.location.id == location.id
  end

  def get_address
    if user_profile.present?
      if user_profile.location_city.present? && user_profile.location_state.present?
        "#{user_profile.location_city}, #{user_profile.location_state}"
      elsif user_profile.location_city.blank? && user_profile.location_state.present?
        "#{user_profile.location_state}"
      elsif user_profile.location_city.present? && user_profile.location_state.blank?
        "#{user_profile.location_city}"
      else
        ''
      end
    else
      ''
    end
  end


  #Class methods goes here
  class << self
    def get_reviewer_of_the_day user_id
      find_by_id user_id
    end

    def fetch_my_friend_requests(request_ids)
      self.where(:id => request_ids)
    end

    def reviewer_of_the_day(current_user)
      reviews = Review.group(:user_id).uniq
      zip_code_matching_users = User.joins(:user_profile).where("users.id IN(?) AND location_zipcode = ? ", reviews.map(&:user_id), current_user.user_profile.location_zipcode)
      matching_set = Review.where("user_id IN(?)",zip_code_matching_users.map(&:id)).group(:user_id).count
      matching_set.present? ? (User.find_by_id matching_set.sort_by {|k, v| v}.reverse.first[0]) : ()
    end

    def is_in_snapgadget?(facebook_id)
      find_by_source_id facebook_id
    end

    def get_fb_friends_and_sg_user(users, current_user)
      sg_users = []
      fb_friends = []
      users.each do |user|
        sg_user = User.find_by_source_id user[:id]
        if sg_user.present? && current_user.is_not_your_friend?(sg_user)
          sg_users << sg_user
        else
          fb_friends << user
        end 
      end
      return sg_users, fb_friends
    end
    
  end #Class methods goes here
  
end