class OfferRedemptionLocation < ActiveRecord::Base
  attr_accessible :redemption_neighborhood, :redemption_country, :redemption_street_address1,
    :redemption_street_address2, :redemption_city, :redemption_state, :redemption_zip_code, :redemption_lat,
    :redemption_lng, :redemption_phone_number, :woeid, :offer_id
  
  belongs_to :offer
  belongs_to :offer_option

  def update_woeid
    if self.redemption_street_address1.present?
      address = "#{self.redemption_street_address1},#{self.redemption_city}, #{self.redemption_state}, #{self.redemption_country}"
    else
      address = "#{self.redemption_city}, #{self.redemption_state}, #{self.redemption_country}"
    end
    address = address.gsub('(', "%28")
    address = address.gsub(')', "%29")
    #address = "ranebennur"
    request_string = "http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20geo.placefinder%20where%20text%3D%22#{CGI::escape(address)}%22&format=json"
    resp = `curl "#{request_string}"`
    if resp.present? && resp.length >= 2
      resp_hash = resp.class == String ? (JSON.parse(resp)) : (resp)
      if resp_hash['query']['results'].present?
        self.woeid = resp_hash['query']['results']['Result'].class == Array ? (resp_hash['query']['results']['Result'][0]['woeid']) : (resp_hash['query']['results']['Result']['woeid'])
      end
    end
  end
  #resp = `curl "http://where.yahooapis.com/geocode?location=#{lat},#{lng}&flags=J&gflags=R&appid=zHgnBS4m"`
end
