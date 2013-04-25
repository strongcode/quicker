class Share < ActiveRecord::Base
  include KudosPoints
  
  attr_accessible :comment, :shareable_id, :shareable_type, :status, :user_id, :trackers
  attr_accessor :trackers

  acts_as_paranoid

  module Status
    SHARE_REQUEST = :share_request
  end
  
  attr_accessor :kudos_score

  belongs_to :user
  belongs_to :shareable, :polymorphic => true
  has_one :activity, :as => :activitable

  state_machine :status, :initial => Status::SHARE_REQUEST do
  end

  validates :comment, :shareable_id, :shareable_type, :status, :user_id, :presence => true
  validates :trackers, :trackers => true
  validates :status, :inclusion => {:in => Status.constants.map { |const| Status.const_get(const).to_s }}, :allow_blank => true
  validates :shareable_type, :inclusion => {:in => [Passionate.to_s, Goal.to_s, LocationList.to_s, Offer.to_s, Location.to_s, Suggestion.to_s]}, :allow_blank => true

  after_save :save_trackers
  after_create :create_share_activity

  scope :get_trackable_or_shareable, proc {|trackable| where("shareable_id = ?", trackable.id)}
  scope :get_share, proc {|tracker| where("shareable_id = ? AND shareable_type = ?", tracker.present? ? (tracker.trackable_id) : (0), tracker.present? ? (tracker.trackable_type) : (0))}

  def save_trackers
    user_ids = self.trackers.reject { |id| id.blank? }
    if user_ids.present?
      users = User.find(user_ids)
      users.each { |user| self.shareable.trackers.create(:user_id => user.id, :shared_from_id => self.user_id)}
    end
  end


  def get_user
    tracker = Tracker.where("trackable_type = ? AND trackable_id =? ", self.shareable_type, self.shareable_id ).first
    tracker.user
  end

  def get_shared_user
    User.find_by_id user_id
  end

  
  
end
