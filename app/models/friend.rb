class Friend < ActiveRecord::Base
  include KudosPoints
  
  module Kudos_Pts
    Accept_Friend_Request = 2
  end
  
  attr_accessible :friend_id, :user_id
  attr_accessor :kudos_score

  after_initialize :set_kudos_score
  default_scope order('created_at desc')

  acts_as_paranoid

  has_one :activity, :as => :activitable
  belongs_to :user

  validates :user_id, :friend_id, :presence => true, :numericality => true

  def set_kudos_score
    @kudos_score = Friend::Kudos_Pts::Accept_Friend_Request
  end

  def icon_path(user_profile)
    if user_profile.present? && user_profile.photo.present? && user_profile.photo.image.present?
      user_profile.photo.image_url(:standard_image)
    elsif user_profile.present? && user_profile.picture.present?
      user_profile.picture
    else
      '/assets/profile-images/blank-profile.png'
    end
  end

  def description
    user = User.find self.friend_id
    "Friend - #{user.full_name}"
  end

  def action
    "Added"
  end
  
end
