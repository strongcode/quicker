class UserProfile < ActiveRecord::Base

  attr_accessible :first_name, :last_name, :language_id, :photo_attributes, :picture, :locale,
    :description, :time_zone, :followers_count, :friends_count, :gender, :relationship_status, :timezone,
    :birthday, :interests, :date_of_birth, :location, :country,
    :photo, :landing_page_id, :offer_category_1, :offer_category_2, :offer_category_3,
    :suggestion_category_1, :suggestion_category_2, :suggestion_category_3, :you_deserve_it_category,
    :lifestyle_on_sidekick, :shopping_on_sidekick, :food_on_sidekick, :business_on_sidekick,
    :friends_on_sidekick, :travel_on_sidekick, :question_3, :question_4, :question_5, :repeat_experiences, 
    :woe_id, :location_name, :location_street, :location_city, :location_state, :location_zipcode,
    :insider_icon_img, :sidekick_icon_img, :assistant_icon_img

  attr_accessor :category_flag, :adv_pref_flag, :customize_avatars, :insider_pref_kudos_pts

  after_initialize :set_insider_pref_kp

  module Kudos_Points
    Insider_preferences = 3
    Six_Questions = 6
    Avatar = 0
  end

  def set_insider_pref_kp
    @insider_pref_kudos_pts = UserProfile::Kudos_Points::Insider_preferences
  end

  after_initialize :set_flags

  belongs_to :user

  has_one :photo, :as => :imageable, :dependent => :destroy
  has_many :activities, :as => :activitable
  
  accepts_nested_attributes_for :photo, :allow_destroy => true

  validates :location_name, :presence => true , :if => :adv_pref_flag_reset? || :avatar_flag_reset?
  
  before_validation :capitalize_name
  before_save :strip_locale_extra
  before_save :check_location, :if => :category_flag_reset?

  def set_flags
    @category_flag = 0
    @adv_pref_flag = 0
    @customize_avatars = 0
  end
  
  def adv_pref_flag_reset?
    @adv_pref_flag == 0
  end

  def category_flag_reset?
    @category_flag == 0
  end

  def avatar_flag_reset?
    @customize_avatars == 0
  end

  def check_location
    if(self.woe_id.blank? || self.location_state.blank?)
      self.errors.add(:base, "Location Invalid")
      return false
    end
  end

  def update_zipcode
    location_text = self.location_street.present? ? ("#{self.location_street}, #{self.location_city}, #{self.location_state}") : (self.location_name)
    if location_text.present?
      request = "http://query.yahooapis.com/v1/public/yql?q=select%20%20name%20from%20geo.places.children%20where%20parent_woeid%20in%20%28select%20woeid%20from%20geo.places%20where%20text%3D%22#{CGI::escape(location_text)}%22%20limit%201%29%20AND%20placetype%20%3D%2011&format=json"
      zipcode_response = `curl "#{request}"`
      zipcode_response = JSON.parse(zipcode_response)
      if zipcode_response['query']['count'] > 0
        self.location_zipcode = zipcode_response['query']['results']['place'].class == Array ? (zipcode_response['query']['results']['place'][0]['name']) : (zipcode_response['query']['results']['place']['name'])
      end
    end
  end

  def set_language
    case self.locale
    when /^en(.)*/i
      self.language_id = Language.find_by_description "English"
    when /^sp(.)*/i
      self.language_id = Language.find_by_description "Spanish"
    else
      self.language_id = Language.find_by_description "English"
    end
    save
  end

  def capitalize_name
    self.first_name = self.first_name.present? ? (self.first_name.capitalize) : (self.first_name)
    self.last_name = self.last_name.present? ? (self.last_name.capitalize) : (self.last_name)
  end

  def populate_locale
    if self.language_id.present?
      lang = Language.find self.language_id
      self.locale = lang.language_sid
    else
      self.locale = "en"
    end
    #save
  end

  def strip_locale_extra
    self.locale = self.locale =~ /^[a-z]{2}_[a-z]{2}$/i ? (self.locale.split('_')[0]) : (self.locale)
  end

  def assistant_icon
    page = SgPage.find_by_id self.landing_page_id
    (page.present? && page.name =~ /assistant/i) ? ("assistant_normal") : ("assistant_disabled")
  end

  def insider_icon
    page = SgPage.find_by_id self.landing_page_id
    (page.present? && page.name =~ /insider/i) ? ("insider_normal") : ("insider_disabled")
  end

  def sidekick_icon
    page = SgPage.find_by_id self.landing_page_id
    logger.debug "*****"
    logger.debug self.landing_page_id
    logger.debug "*****"
    (page.present? && page.name =~ /sidekick/i) ? ("sidekick_normal") : ("sidekick_disabled")
  end

  def offer_category_first
    Category.find_by_id self.offer_category_1
  end

  def offer_category_second
    Category.find_by_id self.offer_category_2
  end

  def offer_category_third
    Category.find_by_id self.offer_category_3
  end

  def suggestion_category_first
    Category.find_by_id self.suggestion_category_1
  end

  def suggestion_category_second
    Category.find_by_id self.suggestion_category_2
  end

  def suggestion_category_third
    Category.find_by_id self.suggestion_category_3
  end

  def deserve_it
    Category.find_by_id self.you_deserve_it_category
  end

  def check_for_category_suggestion_and_deserve_it
    #unless  offer_category_1 || offer_category_2 || offer_category_3
    # errors.add(:base, "Please select at least one Category")
    #end

    #unless  suggestion_category_1 || suggestion_category_2 || suggestion_category_3
    # errors.add(:base, "Please select at least one Suggestion")
    #end

    #    unless  you_deserve_it_category
    #     errors.add(:base, "Please select Deserve it")
    #  end
  end

  def get_default_landing_page
    self.landing_page_id = SgPage.find_by_name('sidekick').try(&:id)
  end

  def visit_or_revisit
    (self.question_1.present? || self.question_2.present? || self.question_3.present? || self.question_4.present? || self.question_5.present?) ? (I18n.t(:change)) : (I18n.t(:add))
  end

  def populate_questions(slider1, slider2, slider3, order1, order2, order3)
    str1 = ''
    str2 = ''
    slider1.present? ? (str1 = str1 + "#{slider1},") : ()
    slider2.present? ? (str1 = str1 + "#{slider2},") : ()
    slider3.present? ? (str1 = str1 + "#{slider3}") : ()
    self.question_1 = str1

    order1.present? ? (str2 = str2 + "#{order1},") : ()
    order2.present? ? (str2 = str2 + "#{order2},") : ()
    order3.present? ? (str2 = str2 + "#{order3}") : ()
    self.question_2 = str2
  end

  def get_class(type)
    case type
    when /lifestyle/i
      "lifestyle_disable"
    when /food/i
      "food_disable"
    when /shopping/i
      "shopping_disable"
    when /business/i
      "business_disable"
    when /travel/i
      "travel_disable"
    when /friends/i
      "friends_active"
    else
      ""
    end
    
  end

  def all_preferences_unset?
    self.offer_category_1.blank? && self.offer_category_2.blank? && self.offer_category_3.blank? && self.suggestion_category_1.blank? && self.suggestion_category_2.blank? && self.suggestion_category_3.blank? && self.you_deserve_it_category.blank?
  end

  def add_or_change
    (self.offer_category_1 || self.offer_category_2 || self.offer_category_3 || self.suggestion_category_first || self.suggestion_category_second || self.suggestion_category_third || self.you_deserve_it_category) ? (I18n.t(:change)) : (I18n.t(:add))
  end

  def icon_path
    if self.present? && self.photo.present? && self.photo.image.present?
      photo.image_url(:standard_image)
    elsif self.present? && self.picture.present?
      picture
    else
      "/assets/profile-images/blank-profile.png"
    end
  end

  class << self
    def pref_completeness(user)
      percentage = 0.0
      prefs = self.select("question_1, question_2, question_3, question_4, question_5").where(:user_id => user.id)
      prefs.each do |pref|
        percentage = percentage + (pref.question_1 == '0,0,0' || pref.question_1.blank?  ? (0) : (20))
        percentage = percentage + (pref.question_2.present? ? (20) : (0))
        percentage = percentage + (pref.question_3 == '0' || pref.question_3.blank? ?  (0) : (20))
        percentage = percentage + (pref.question_4 == '0' || pref.question_4.blank? ?  (0) : (20))
        percentage = percentage + (pref.question_5 == '0' || pref.question_5.blank? ?  (0) : (20))
      end

      percentage.round > 100.0 ? (percentage.round - (percentage.round - 100)) : (percentage.round)
    end
  end

end

#http://query.yahooapis.com/v1/public/yql?q=select%20%20name%20from%20geo.places.children%20where%20parent_woeid%20in%20%28select%20woeid%20from%20geo.places%20where%20text%3D%22broomfield%20Co%22%20limit%201%29%20AND%20placetype%20%3D%2011&format=json