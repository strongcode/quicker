class ZipLatLng < ActiveRecord::Base
  attr_accessible :zipcode, :primary_city, :state, :latitude, :longitude, :division, :ls_division

  def populate_by_lat_lng request
    response = `curl "#{request}"`
    if response && response.length >= 2
      response = JSON.parse(response)
      if response['pagination'].present? && response['pagination']['count'] > 0
        self.division = response['deals'][0]['division']['id']
        CityDivision.create(:primary_city => primary_city, :state => state, :division => division)
      end
      save
    end
  end

  class << self
    def groupon_division_id(location_zipcode)
      zip_lat_lng = where('zipcode = ? ', location_zipcode).first
      zip_lat_lng.present? ? (zip_lat_lng.division) : ("las-vegas")
    end
    
    def living_social_division_id(location_zipcode)
      zip_lat_lng = where('zipcode = ? ', location_zipcode).first
      zip_lat_lng.present? ? (zip_lat_lng.ls_division) : ("30")
    end
  end
end
