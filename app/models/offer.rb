class Offer < ActiveRecord::Base
  extend PopulateOffers

  module Kudos_Pts
    Share_Deal = 2
    Snap_Offer = 5
  end

  module Category_Score
    Slot_1_Pts = 200
    Slot_2_Pts = 150
    Slot_3_Pts = 100
    You_Deserve_It_Pts = 600
    Local_Pts = 210
    State_Pts = 100
  end

  module States
    List = ["AL","AK","AZ","AR","CA","CO","CT","DE","DC","FL","GA","HI","ID","IL",
      "IN","IA","KS","KY","LA","ME","MD","MA","MI","MN","MS","MO","MT","NE","NV",
      "NH","NJ","NM","NY","NC","ND","OH","OK","OR","PA","RI","SC","SD","TN",
      "TX","UT","VT","VA","WA","WV","WI","WY"]
  end

  cattr_accessor :unique_offers_list
  
  attr_accessible :deal_source, :deal_id, :merchant_name, :category_id, :deal_type,
    :merchant_type, :national_deal, :local_deal, :division_id, :division_lat, :division_lng,
    :large_image_url, :small_image_url, :status, :deal_url, :deal_header, :deal_highlights,
    :deal_start, :deal_updated, :deal_end, :deal_tipped, :deal_tipped_at, :redemption_neighborhood,
    :redemption_country, :redemption_street_address1, :redemption_street_address2,
    :redemption_city, :redemption_state, :redemption_zip_code, :redemption_lat, :redemption_long,
    :redemption_phone_number, :value_currency, :value_amount, :price_currency, :price_amount, 
    :discount_currency, :discount_amount, :discount_percent, :yelp_id, :yelp_reviews_count,
    :yelp_rating, :woe_id, :number_sold, :trend_score, :snapgadget_category_id, :redemption_location

  belongs_to :user
  belongs_to :category
  has_many :shares, :as => :shareable, :dependent => :destroy
  has_many :trackers, :as => :trackable, :dependent => :destroy
  has_many :offer_options, :dependent => :destroy
  has_many :offer_redemption_locations, :dependent => :destroy
  has_many :offer_merchant_ratings, :dependent => :destroy
  has_many :insider_activities, :dependent => :destroy
  has_many :activities, :as => :activitable

  scope :offers_i_want, proc {|user_profile| where('snapgadget_category_id = ? OR snapgadget_category_id = ? 
                                                   OR snapgadget_category_id = ?',
      user_profile.offer_category_1,
      user_profile.offer_category_2,
      user_profile.offer_category_3 )}
                                               
  scope :offers_i_want_or_you_deserve_it, proc {|user_profile| where('snapgadget_category_id = ? OR 
                                                               snapgadget_category_id = ? OR
                                                               snapgadget_category_id = ? OR
                                                               snapgadget_category_id = ?',
      user_profile.offer_category_1,
      user_profile.offer_category_2,
      user_profile.offer_category_3,
      user_profile.you_deserve_it_category )}

  scope :offers_i_want_with_deal_source, proc {|category_ids, user_profile|
    where('snapgadget_category_id IN(?) AND (division_id like ? OR division_id like ?)',
      category_ids, ZipLatLng.groupon_division_id(user_profile.location_zipcode),
      ZipLatLng.living_social_division_id(user_profile.location_zipcode) )}
                                          
  scope :get_local_offers, proc {|current_user| joins(:offer_redemption_locations).
      limit(1).where('offer_redemption_locations.woeid = ?',
      current_user.user_profile.woe_id)}
                                            
  scope :you_deserve_it_offers, proc {|user_profile| where('snapgadget_category_id = ?',
      user_profile.you_deserve_it_category)}

  scope :you_deserve_it_offers_with_deal_source, proc {|category_ids, user_profile|
    where('snapgadget_category_id IN(?) AND (division_id like ? OR division_id like ? )',
      category_ids,
      ZipLatLng.groupon_division_id(user_profile.location_zipcode),
      ZipLatLng.living_social_division_id(user_profile.location_zipcode))}
                                             
  scope :with_deal_source, proc {|user_profile| where("division_id like ? OR division_id like ?",
      ZipLatLng.groupon_division_id(user_profile.location_zipcode),
      ZipLatLng.living_social_division_id(user_profile.location_zipcode))}
                            
  scope :matching_offers, proc {|category_ids| where("snapgadget_category_id IN(?)", category_ids)}

  scope :not_online_deals, where("id IN(select offer_id from offer_redemption_locations 
                                WHERE offers.id = offer_redemption_locations.offer_id AND offer_redemption_locations.redemption_country like ?)", 'US')

  scope :city_matching_offers, proc {|current_user| where("id IN(SELECT offer_id
                                    FROM offer_redemption_locations WHERE
                                    offers.id = offer_redemption_locations.offer_id AND
                                    offer_redemption_locations.redemption_city like ?)",
      current_user.user_profile.location_city)}
                                
  scope :state_matching_offers, proc {|current_user| where("id IN(SELECT offer_id FROM
                                      offer_redemption_locations
                                      WHERE offers.id = offer_redemption_locations.offer_id
                                      AND offer_redemption_locations.redemption_state like ?)",
      current_user.user_profile.location_state)}
                                 
  scope :non_city_and_state_offers, proc {|current_user| where("id IN(SELECT offer_id FROM
                                       offer_redemption_locations
                                       WHERE offers.id = offer_redemption_locations.offer_id AND
                                       offer_redemption_locations.redemption_state NOT like ? AND
                                       offer_redemption_locations.redemption_city NOT like ? )",
      current_user.user_profile.location_state,
      current_user.user_profile.location_city)}

  scope :division_matching_offers, proc {|current_user| where("division_id like ? OR division_id like ? ",
      ZipLatLng.groupon_division_id(current_user.user_profile.location_zipcode),
      ZipLatLng.living_social_division_id(current_user.user_profile.location_zipcode))}
                                    
  scope :division_or_state_matching_offers, proc {|current_user| where("division_id like ? OR division_id like ?
                                                 id IN(SELECT offer_id FROM offer_redemption_locations WHERE
                                                 offers.id = offer_redemption_locations.offer_id AND
                                                 offer_redemption_locations.redemption_state like ?)",
      ZipLatLng.groupon_division_id(current_user.user_profile.location_zipcode),
      ZipLatLng.living_social_division_id(current_user.user_profile.location_zipcode),
      current_user.user_profile.location_state )}
                                             
  scope :shared_to_me, proc {|current_user| where("id IN(SELECT shareable_id from shares WHERE
                             (SELECT trackable_id FROM trackers WHERE
                             shares.shareable_id = trackers.trackable_id AND
                             shares.shareable_type = ? AND trackers.trackable_type = ? AND
                             trackers.user_id = ? ))", Offer.to_s, Offer.to_s, current_user.id)}
  
  scope :snap_add, proc {|user_profile| where("(snapgadget_category_id = ? OR snapgadget_category_id = ? OR
                        snapgadget_category_id = ? OR snapgadget_category_id = ?) AND
                        deal_source like ? AND division_id like ? ", user_profile.offer_category_1,
      user_profile.offer_category_2, user_profile.offer_category_3,
      user_profile.you_deserve_it_category, "snapadd",
      ZipLatLng.groupon_division_id(user_profile.location_zipcode) )}

  def update_trend_score(orders_count = nil)
    start_date = self.deal_start.utc.to_date
    till_date = self.deal_end.present? ? self.deal_end.utc.to_date : Time.now.utc.to_date
    available_offer_days = (till_date - start_date).to_i
    if orders_count.present?
      self.trend_score = ((orders_count.to_i || 0) / available_offer_days.to_f)
    else
      self.trend_score = ((self.offer_options.map(&:number_sold).sum || 0) / available_offer_days.to_f)
    end
    
  end

  def is
    SG::INSIDER
  end

  def assign_local_and_state_points(user_profile)
    if self.offer_redemption_locations.present?
      if self.offer_redemption_locations.first.redemption_zip_code == user_profile.location_zipcode
        self.score = self.score + Offer::Category_Score::Local_Pts
      elsif self.offer_redemption_locations.first.redemption_state == user_profile.location_state
        self.score = self.score + Offer::Category_Score::State_Pts
      end
    end
  end

  def get_snapgadget_category_id_groupon
    external_category = GrouponExternalCategory.find_by_groupon_category_id self.category_id
    if external_category.present?
      self.snapgadget_category_id = external_category.snapgadget_category_id
    else
      self.snapgadget_category_id = Category.where("major_category like ? AND minor_category like ?",
        "shopping", "shopping")
    end
  end
  
  def get_snapgadget_category_id_living_social
    external_category = LivingSocialExternalCategory.find_by_living_social_category_id self.category_id
    if external_category.present?
      self.snapgadget_category_id = external_category.snapgadget_category_id
    else
      self.snapgadget_category_id = Category.where("major_category like ? AND minor_category like ?",
        "shopping", "shopping")
    end
  end

  def icon_path(user_profile)
    "/assets/advisor_icons/insider/#{user_profile.present? ? (user_profile.insider_icon_img) : ("insider_male_d6c4c2_ffd8b6")}.png"
  end

  def action
    ""
  end

  def share_description
    "Deal - #{merchant_name}"
  end

  def share_action
    "Shared"
  end

  def set_share_score
    Offer::Kudos_Pts::Share_Deal
  end

  def you_save_description
    price_amount = offer_options.order('price_amount ASC').first.price_amount
    discount_amount = offer_options.order('price_amount ASC').first.discount_amount
    if price_amount.present?
      price_amount =  price_amount = price_amount.include?("$") ? (price_amount) : (sprintf("%0.02f", price_amount.to_f))
    else
      price_amount = ''
    end
    if discount_amount.present?
      you_save =  "YOU SAVE #{discount_amount.include?("$") ? (discount_amount) : (sprintf("%0.02f", discount_amount.to_f))} (#{offer_options.order('price_amount ASC').first.discount_percent}%)"
    else
      you_save = "YOU SAVE (#{offer_options.order('price_amount ASC').first.discount_percent}%)"
    end
    price_amount + ' ' + you_save
  end

  #Class methods goes here
  class << self

    def initialize_unique_offers_list
      Offer.unique_offers_list = [-9999]
    end

    def get_matching_offers(user_profile)
      category_ids = Category.user_preference_categories(user_profile)
      offers_i_want_with_deal_source = offers_i_want_with_deal_source(category_ids, user_profile)
      offers_i_want = offers_i_want_with_deal_source
      
      offers_i_want.each do |offer|
        offer.score = 0
        case offer.snapgadget_category_id
          
        when user_profile.offer_category_1
          offer.score = offer.score + Offer::Category_Score::Slot_1_Pts
        when user_profile.offer_category_2
          offer.score = offer.score + Offer::Category_Score::Slot_2_Pts
        when user_profile.offer_category_3
          offer.score = offer.score + Offer::Category_Score::Slot_3_Pts
        end
        
        offer.assign_local_and_state_points(user_profile)
        offer.save
      end
      offers = offers_i_want.joins(:offer_options).order('offers.score DESC').
        order('offer_options.discount_percent DESC').group('offers.id')
      offers.where("offers.id NOT IN(?)", Offer.unique_offers_list)
    end

    def special_offer_of_the_day(current_user)
      user_profile = current_user.user_profile
      special_offer = get_matching_offers(user_profile).first
      Offer.unique_offers_list << special_offer.id if special_offer.present?
      InsiderActivity.populate(special_offer, current_user,
        InsiderActivity::Activity_Type::Special_Offer) if special_offer.present?
      special_offer
    end

    def you_deserve_it_offer(current_user)
      user_profile = current_user.user_profile
      category_ids = Category.you_deserve_it_set(user_profile)
      offers_with_deal_source = you_deserve_it_offers_with_deal_source(category_ids, user_profile)
      
      offers_with_deal_source.each do |offer|
        offer.score = 0
        offer.score = offer.score + Offer::Category_Score::You_Deserve_It_Pts
        offer.assign_local_and_state_points(user_profile)
        offer.save
      end
      you_deserve_it = offers_with_deal_source.joins(:offer_options).
        order('offers.score DESC').
        order('offer_options.discount_percent DESC').
        where("offers.id NOT IN(?)", Offer.unique_offers_list).first
                                             
      Offer.unique_offers_list <<  you_deserve_it.id if you_deserve_it.present?
      InsiderActivity.populate(you_deserve_it, current_user,
        InsiderActivity::Activity_Type::Deserve_It) if you_deserve_it.present?
      you_deserve_it
    end

    #    def insider_do_better_offer(current_user)
    #      user_profile = current_user.user_profile
    #      do_better_offer = get_matching_offers(user_profile).where("offers.id NOT IN(?)", @deserve_it.present? ? (@deserve_it.id) : (0)).limit(1).offset(1).first
    #      InsiderActivity.populate(do_better_offer, current_user, InsiderActivity::Activity_Type::Insider_Do_Better) if do_better_offer.present?
    #      do_better_offer
    #    end

    def trending_deals(current_user)
      user_profile = current_user.user_profile
      offers = with_deal_source(user_profile).offers_i_want_or_you_deserve_it(user_profile).order("trend_score DESC").
        where("id NOT IN(?)", Offer.unique_offers_list)
                                                         
      Offer.unique_offers_list = (Offer.unique_offers_list + offers.map(&:id)).uniq if offers.present?
      offers.first if offers.present?
    end

    def preferred_deal(current_user)
      user_reviews_to_consider = current_user.reviews.where(:allow_personal_offers => true)
      reviewed_locations = Location.where("id IN(?)", user_reviews_to_consider.map(&:location_id))
      required_location_woeids = reviewed_locations.map(&:WOEID)
      offers = joins(:offer_options, :offer_redemption_locations).
        where("offer_redemption_locations.woeid IN(?)",
        required_location_woeids).order('offer_options.discount_percent DESC')
             
      query = reviewed_locations.map {|location|
        "SUBSTRING(offer_redemption_locations.redemption_street_address1, 1, 5) like
                                 '#{location.street_address[0..4]}'"}.join(" OR ")
      
      preferred_deal = offers.joins(:offer_redemption_locations).where(query).first
      InsiderActivity.populate(preferred_deal, current_user,
        InsiderActivity::Activity_Type::Preferred_Deal) if preferred_deal.present?
      Offer.unique_offers_list << preferred_deal.id if preferred_deal.present?
      preferred_deal
    end

    def search(major_category, local, current_user)
      matching_categories = Category.where("major_category like
                                         '%#{major_category.downcase}%'") unless major_category.match(/all/i)

      if major_category.match(/all/i) && local.present?
        offers = division_matching_offers(current_user).not_online_deals(current_user)
      elsif major_category.match(/all/i) && local.blank?
        offers = division_matching_offers(current_user)
      elsif !major_category.match(/all/i) && local.present?
        offers = matching_offers(matching_categories.map(&:id)).
          division_matching_offers(current_user).
          not_online_deals(current_user)
      elsif !major_category.match(/all/i) && local.blank?
        offers = matching_offers(matching_categories.map(&:id)).division_matching_offers(current_user)
      end
      offers
    end

  end

end

#1731