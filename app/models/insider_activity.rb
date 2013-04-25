class InsiderActivity < ActiveRecord::Base
  attr_accessible :user_id, :offer_id, :activity_type, :presented, :no_of_times_presented,
    :snapped

  belongs_to :user
  belongs_to :offer

  scope :presented, where("presented IS NOT NULL")
  scope :snapped, where("snapped IS NOT NULL")
  scope :matching_activities, proc {|offer| where("offer_id = ?", offer.id )}

  module Activity_Type
    Special_Offer = "special offer"
    Insider_Do_Better = "insider do better"
    Preferred_Deal = "preferred deal"
    Deserve_It = "deserve it"
    Search_Offer = "search offer"
    #Activity_List = [Special_Offer, Insider_Do_Better, Preferred_Deal, Deserve_It ]
  end

  class << self
    def populate(offer, current_user, activity_type)
      activity = current_user.insider_activities.matching_activities(offer).first
      if activity.present?
        activity.no_of_times_presented += 1
        activity.save
      else
        activity = current_user.insider_activities.build(:offer_id => offer.id, :presented => Time.zone.now, :no_of_times_presented => 1, :activity_type => activity_type)
        activity.save
      end
      activity
    end

    def get_snap_track(offer, current_user)
      activity = current_user.insider_activities.matching_activities(offer).first
      if activity.present? && activity.activity_type.present? && activity.snapped.blank?
        activity.snapped = Time.zone.now
        activity.save
      elsif activity.blank?
        activity = current_user.insider_activities.build(:presented => Time.zone.now, :snapped => Time.zone.now, :offer_id => offer.id)
        activity.save
      end
    end
    #    def populate_activities(offer_1 = nil, offer_2 = nil, offer_3 = nil, user )
    #      if offer_1.present?
    #        create_insider_activity(user, offer_1, "Special Offer")
    #      end
    #
    #      if offer_2.present?
    #        create_insider_activity(user, offer_2, "PreferredDeal")
    #      end
    #
    #      if offer_3.present?
    #        create_insider_activity(user, offer_3, "YouDeserveIt")
    #      end
    #
    #    end
    #
    #    def create_insider_activity(user, offer, type)
    #      insider_activity = InsiderActivity.where('user_id = ? AND offer_id = ?', user.id, offer.id).first
    #      if insider_activity.present?
    #        insider_activity.no_of_times_presented = insider_activity.no_of_times_presented + 1
    #        insider_activity.save
    #      else
    #        insider_activity = self.create(:user_id => user.id, :offer_id => offer.id, :activity_type => type, :presented => Time.now, :no_of_times_presented => 1)
    #      end
    #    end
    
  end

end
