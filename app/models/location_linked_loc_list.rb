class LocationLinkedLocList < ActiveRecord::Base
  attr_accessible :location_id, :location_list_id

  acts_as_paranoid

  belongs_to :location
  belongs_to :location_list

  validates :location_list_id, :uniqueness => {:scope => [:location_id, :deleted_at], :message => ' already contains'}

  after_destroy :customized_after_destroy

  def customized_after_destroy
    self.location_list.destroy if self.location_list.location_linked_loc_lists.count.zero?
  end

  class << self
    
    def check_location_list_for_locations(location_list)
      where("location_id IN(?) AND location_list_id NOT IN(?)", location_list.locations.map(&:id), location_list.id)
    end

    def check_location_in_list(location_list, location)
      where("location_id = ? AND location_list_id NOT IN(?)", location.id, location_list.id).map(&:location_list_id)
    end
    
  end

end
