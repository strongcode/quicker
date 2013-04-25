class Review < ActiveRecord::Base
  include KudosPoints
  
  attr_accessible :user_id, :location_id, :review_status, :review_been_seen, :review_approvals,
    :user_quick_star, :allow_personal_offers, :review_details, :kudos_points, :photos_attributes

  #validates :review_details, :presence => true

  module Kudos_Pts
    Create_Review = 2
  end
  
  attr_accessor :kudos_score
  after_initialize :set_kudos_score
  #after_validation :update_kudos_points

  def set_kudos_score
    @kudos_score = Review::Kudos_Pts::Create_Review
  end
  
  belongs_to :user
  belongs_to :location
  has_many :photos, :as => :imageable, :dependent => :destroy
  accepts_nested_attributes_for :photos, :allow_destroy => true

  has_one :activity, :as => :activitable

  after_create :create_activity

  scope :snapgadget_reviews, proc {|user| where('user_id NOT IN(?)', user.friends.map(&:friend_id) + [user.id])}
  scope :my_and_friends_reviews, proc {|user| where("user_id IN (?)", user.friends.map(&:friend_id) + [user.id])}
  scope :friends_reviews, proc {|user| where("user_id IN (?)", user.friends.map(&:friend_id))}
  scope :my_review, proc {|user| where("user_id IN (?)", [user.id])}
  scope :trusted_reviews, proc {|rev_of_the_day| where("id = ?", rev_of_the_day.user_id).count}
  scope :location_reviews, proc {|location| where("location_id IN(SELECT locations.id FROM locations WHERE locations.id = location_id AND locations.id IN(?) )", Location.locations_with_woeid_and_name(location).map(&:id))}
  scope :my_friends_reviews, proc {|location, current_user| where("location_id IN(?) AND user_id IN(?)", Location.locations_with_woeid_and_name(location).map(&:id), current_user.friends.map(&:friend_id)).order("created_at ASC")}
  scope :other_reviews, proc {|location, current_user| where("location_id IN(?) AND user_id NOT IN(?)", Location.locations_with_woeid_and_name(location).map(&:id), ([current_user.id] + current_user.friends.map(&:friend_id)).presence || [-9999]).order("created_at ASC")}
  scope :with_comment, where("review_details != ''")

  Reviewers = ["My Friends Reviews", "SnapGadget Reviews"]

  def icon_path(user_profile)
    "/assets/advisor_icons/sidekick/#{user_profile.present? ? (user_profile.sidekick_icon_img) : ("sidekick_male_d6c4c2_ffd8b6")}.png"
  end

  def description
    self.location.present? ? ("#{self.location.name}") : ('')
  end

  def action
    I18n.t(:reviewed)
  end


  def is
    SG::SIDEKICK
  end

  class << self
    def review_link(location)
      review = where('location_id = ?', location.id)[0]
      review.present? ? (Rails.application.routes.url_helpers.edit_sidekick_location_review_path(location.id, review.id)) : (Rails.application.routes.url_helpers.new_sidekick_location_review_path(location.id))
    end

  end

end