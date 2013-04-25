class OfferZipDeal < ActiveRecord::Base
 attr_accessible :zipcode, :latitude, :longitude, :groupon_division, :livingsocial_division

  class << self
    def get_deal(location_zipcode)
      offer_zip_deal = where('zipcode = ? ', location_zipcode).first
      offer_zip_deal.present? ? (offer_zip_deal.groupon_division) : ("las-vegas")
    end
  end
end
