class Passionate < ActiveRecord::Base
  include KudosPoints
  
  attr_accessible :user_id, :name, :snapgadget_category_id, :location_id, :passionate_text, :url, :kudos_points,
    :photo, :photo_attributes

  module Kudos_Pts
    Create_Passionate = 2
  end
  
  attr_accessor :kudos_score
  after_initialize :set_kudos_score
  
  acts_as_paranoid
 
  has_one :photo, :as => :imageable, :dependent => :destroy
  has_one :activity, :as => :activitable

  has_many :trackers, :as => :trackable, :dependent => :destroy
  has_many :shares, :as => :shareable, :dependent => :destroy

  belongs_to :user
  belongs_to :location

  accepts_nested_attributes_for :photo, :allow_destroy => true

  validates :name, :presence => true

  after_create :create_activity

  scope :passionate_count, proc {|location| where("location_id IN(?)", Location.locations_with_woeid_and_name(location).map(&:id))}
  scope :friends_passionates, proc {|location, current_user| where("location_id IN(?) AND user_id IN(?)", Location.locations_with_woeid_and_name(location).map(&:id), current_user.friends.map(&:friend_id)).order('created_at ASC')}
  scope :other_passionates, proc {|location, current_user| where("location_id IN(?) AND user_id NOT IN(?)", Location.locations_with_woeid_and_name(location).map(&:id), ([current_user.id] + current_user.friends.map(&:friend_id)).presence || [-9999]).order('created_at ASC')}

  def set_kudos_score
    @kudos_score = Passionate::Kudos_Pts::Create_Passionate
  end

  def description
    self.name.present? ? ("Passionate - #{self.name}"):('')
  end

  def action
    I18n.t(:added)
  end

  def icon_path(user_profile)
    "/assets/advisor_icons/sidekick/#{user_profile.present? ? (user_profile.sidekick_icon_img):("sidekick_male_d6c4c2_ffd8b6")}.png"
  end

  def this_location?(location)
    Location.locations_with_woeid_and_name(location).map(&:id).include?(self.location_id)
  end

  #before_validation :_before_validation, :on => :create

  #  def _before_validation
  #    if Passionate.where(:user_id => self.user_id).count >= MAX_PASSIONATE_ALLOWED_FOR_USER
  #      errors.add(:base, "Only #{MAX_PASSIONATE_ALLOWED_FOR_USER} Passionates can be active")
  #    end
  #  end
end
