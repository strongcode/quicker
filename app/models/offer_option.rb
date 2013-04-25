class OfferOption < ActiveRecord::Base
  attr_accessible :number_sold, :value_currency, :value_amount, :price_currency, :price_amount,
    :discount_currency, :discount_amount, :discount_percent, :trend_score, :offer_id
  
  belongs_to :offer
  has_many :offer_redemption_locations, :dependent => :destroy
end
