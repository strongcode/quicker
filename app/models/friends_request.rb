class FriendsRequest < ActiveRecord::Base
  include KudosPoints
  
  module Kudos_Pts
    Add_Friend = 2
  end
  attr_accessible  :friend_request_id, :friend_from_id, :friend_to_id, :friend_from_message,
    :state

  attr_accessor :kudos_score
  after_initialize :set_kudos_score
  after_create :create_fr_activity
  
  default_scope order('created_at DESC')
  

  state_machine :initial => :unread do

    event :accept do
      transition :unread => :accept
    end
    
    event :archive do
      transition :unread => :archive
    end

    event :archive_accept do
      transition :archive => :accept
    end
    
  end

  has_one :activity, :as => :activitable
  belongs_to :user, :foreign_key => :friend_to_id
  
  scope :request_comment, proc {|user| where('friend_from_id = ?', user.id)}
  #after_validation :update_kudos_points

  def set_kudos_score
    @kudos_score = FriendsRequest::Kudos_Pts::Add_Friend
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

  def description
    user = User.find self.friend_to_id
    "Friend Request - #{user.full_name}"
  end

  def action
    "Added"
  end

  # Class Methods goes here

  class << self

    def invite_sg_users(sg_user_ids, current_user)
      sg_user_ids.each do |user_id|
        create(:friend_from_id => current_user.id, :friend_to_id => user_id)
      end
    end

  end
  
end