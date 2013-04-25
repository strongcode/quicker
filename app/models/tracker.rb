class Tracker < ActiveRecord::Base
  attr_accessible :trackable_id, :trackable_type, :user_id, :shared_from_id

  acts_as_paranoid

  validates :trackable_id, :trackable_type, :user_id, :presence => true
  validates :trackable_type, :inclusion => {:in => [Goal.to_s, LocationList.to_s, Passionate.to_s, Offer.to_s, LocationList.to_s, Suggestion.to_s, Location.to_s]}

  belongs_to :trackable, :polymorphic => true
  belongs_to :user
  belongs_to :shared_from_user, :class_name => User, :foreign_key => :shared_from_id

  scope :goals, where(:trackable_type => Goal.to_s)
  scope :offers, where(:trackable_type => Offer.to_s)
  scope :location_lists, where(:trackable_type => LocationList.to_s)
  scope :passionates, where(:trackable_type => Passionate.to_s)
  scope :shared_to_me, proc{|current_user, type| where("trackable_id IN(SELECT shareable_id FROM shares WHERE trackers.trackable_id = shares.shareable_id AND trackers.trackable_type = ? AND trackers.user_id = ? )", type, current_user.id)}
  scope :get_trackers_since_lda, proc {|current_user| where("created_at >= ?", current_user.lda)}
  scope :get_tracker, proc {|current_user, type, object| where("user_id IN(?) AND trackable_type = ? AND trackable_id = ?", current_user, type, object.id)}
  scope :my_tracker,  proc {|current_user| where("user_id IN(?)", current_user.id)}

  def get_share
    Share.where("shareable_type = ? AND shareable_id = ? ", trackable_type, trackable_id).first
  end

  #class methods goes here
  class << self
    def non_shared_friends(object, current_user)
      trackers = object.trackers.where("shared_from_id = ?", current_user.id)
      non_shared_ids = current_user.friends.map(&:friend_id) - trackers.map(&:user_id)
      User.find non_shared_ids
    end
  end

end
