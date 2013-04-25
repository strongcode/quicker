class LocationList < ActiveRecord::Base
  include KudosPoints
  
  attr_accessible :user_id, :name, :type

  module Kudos_Pts
    Create_Location_List = 1
    Share_Location_List = 2
  end

  Minimum_Locations_Count = 1

  attr_accessor :kudos_score
  
  validates :locations, :name, :presence => true
  validates :name, :uniqueness => {:scope => :user_id}
  
  has_many :location_linked_loc_lists, :dependent => :delete_all
  has_many :locations, :through => :location_linked_loc_lists
  has_many :shares, :as => :shareable, :dependent => :destroy
  has_many :trackers, :as => :trackable, :dependent => :destroy

  has_many :activities, :as => :activitable

  belongs_to :user

  after_initialize :set_kudos_score
  after_create :create_activity

  scope :friends_location_lists, proc {|user| where("id IN(SELECT trackable_id FROM trackers WHERE location_lists.id = trackers.trackable_id AND trackable_type = ? AND trackers.user_id = ?)", LocationList.to_s, user.id)}
  scope :shared_location_lists,
    proc {|current_user| where('id IN(SELECT trackable_id from trackers WHERE trackers.deleted_at IS NULL AND location_lists.id = trackers.trackable_id AND trackers.trackable_type = ? AND trackers.user_id IN(?))', LocationList.to_s, current_user.id) }
  scope :popular_locations, proc {|location| joins(:location_linked_loc_lists).where("location_linked_loc_lists.location_id IN(?)", Location.locations_with_woeid_and_name(location).map(&:id))}
  
  def is
    SG::SIDEKICK
  end

  def set_kudos_score
    @kudos_score = LocationList::Kudos_Pts::Create_Location_List
  end
  
  def confirm_message
    self.locations.count > 1 ? "Are you Sure?" : "This will also delete the list as lists must have 1 location, are you sure?"
  end

  #Clone the Friend location list / Own location list and add a location if location is present.
  def add_location_and_clone_list(current_user, location = nil, name = nil)
    if current_user.friends.present? && current_user.friends.map(&:friend_id).include?(self.user_id)
      new_list = clone_list(current_user, name)
      new_list.add_location(self, location, current_user)
      new_list.name = name unless name.nil?
      new_list.original_share_id = self.shares.first.id if self.shares.present?
      new_list
    else
      begin
        self.locations << location if location.present?
        self.name = name unless name.nil?
        self
      rescue
        self
      end
    end
  end
  
  def remove_location_and_clone_list(location, current_user)
    if current_user.friends.present? && current_user.friends.map(&:friend_id).include?(self.user_id)
      new_list = clone_list(current_user)
      new_list.locations = self.clone_locations(current_user) - current_user.locations.locations_with_woeid_and_name(location)
      new_list.original_share_id = self.shares.first.id if self.shares.present?
      new_list
    else
      location_linked_loc_lists.where(:location_id => location.id).destroy_all
      self
    end
    
  end

  def add_location(location_list, location, current_user)
    if location.present?
      self.locations = location_list.clone_locations(current_user) + [location]
    else
      self.locations = location_list.clone_locations(current_user)
    end
  end

  def clone_list(current_user, name = nil )
    current_user.location_lists.build(:name => self.name || name)
  end

  def clone_locations(current_user)
    location_set = []
    locations.each do |location|
      #used to prevent duplicate locations if user has already created this location.
      new_location = current_user.locations.locations_with_woeid_and_name(location).first
      if new_location.present?
        location_set << new_location
      else
        new_location = location.dup
        new_location.user_id = current_user.id
        location_set << new_location if new_location.save
      end
    end
    location_set
  end

  def remove_tracker(current_user)
    tracker = self.trackers.my_tracker(current_user)
    tracker.first.destroy if tracker.present?
  end

  def description
    "Location List - #{self.name}"
  end

  def action
    "Added"
  end

  def icon_path(user_profile)
    "/assets/advisor_icons/sidekick/#{user_profile.sidekick_icon_img}.png"
  end

  def share_description
    "Location List - #{name}"
  end

  def share_action
    "Shared"
  end

  def set_share_score
    LocationList::Kudos_Pts::Share_Location_List
  end

  def original_owner
    if original_share_id.present?
      share = Share.find_by_id original_share_id
      share.present? ? (" - Originally shared by #{share.user.full_name}") : ("")
    else
      ""
    end
  end

  def original_share_comment
    if original_share_id.present?
      share = Share.find_by_id original_share_id
      share.present? ? ("Original Comment  - #{share.comment}") : ("")
    else
      ""
    end
  end

  def custom_title(trackers)
    if trackers.present?
      "#{user.full_name} - #{name} - #{trackers.first.get_share.comment}"
    else
      "#{user.full_name} - #{name}#{original_owner}"
    end
  end

  class << self

    def find_location_list_and_populate_with_location(current_user, location_list_id, location, list_name )
      location_list = find_by_id location_list_id
      if location_list.present?
        new_list = location_list.add_location_and_clone_list(current_user, location)
      else
        new_list = create_list_add_location(current_user, location, list_name)
      end
      new_list
    end

    def create_list_add_location(current_user, location, list_name)
      location_list = current_user.location_lists.build
      location_list.name = list_name
      location_list.locations << location
      location_list
    end

  end
  
end
