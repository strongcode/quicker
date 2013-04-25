class OfferMerchantRating < ActiveRecord::Base
  attr_accessible :merchant_rating_site, :merchant_rating_score, :merchant_rating_reviews, :offer_id
  
  belongs_to :offer
  belongs_to :offer_option
  
end
