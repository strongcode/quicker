module Insider
  class OffersController < ApplicationController
    before_filter :authenticate_user!
    #before_filter :check_for_guide, :only => [:index]

    def index
      session[:trail] = 'insider'
      Offer.initialize_unique_offers_list
      @preferred_deal_offer = Offer.preferred_deal(current_user)
      @special_offer = Offer.special_offer_of_the_day(current_user)
      @you_deserve_it_offer = Offer.you_deserve_it_offer(current_user)
      @trending_deal = Offer.trending_deals(current_user)
      @deal_trackers = Tracker.shared_to_me(current_user, Offer.to_s).order('created_at DESC')
      @snap_add = Offer.snap_add(@user_profile).sample
      @all_suggestions_execpt_friends = Suggestion.all_except_friends_suggestions(current_user)
      @friends_suggestions = Suggestion.friends_suggestions(current_user)
      @suggestion_trackers = Tracker.shared_to_me(current_user, Suggestion.to_s).order('created_at DESC')
      @minor_categories = Category.get_sorted_minor_categories('lifestyle')
      #@insider_do_better_offer = Offer.insider_do_better_offer(current_user)
      logger.debug "*******"
      logger.debug @preferred_deal_offer.class
      logger.debug @special_offer.class
      logger.debug @you_deserve_it_offer.class
      logger.debug @trending_deal.class
      logger.debug @deal_trackers.map(&:id)
      logger.debug "*******"
    end

    def insider_do_better
      @deserve_it = session[:deserve_it]
      session[:deserve_it] = nil
      @preferred_deal_offer = Offer.preferred_deal(current_user)
      @insider_do_better_offer = Offer.insider_do_better_offer(current_user)
      @trending_deals = Offer.trending_deals(current_user)
      @minor_categories = Category.get_sorted_minor_categories('lifestyle')
    end

    def update_minor_categories
      major_category_string = params[:major_category].split(' ').first
      @minor_categories = Category.get_sorted_minor_categories(major_category_string)
    end

    def insider_search
      if params[:search_offers].present? && params[:search_offers][:major_category].present?
        search_offers = params[:search_offers][:major_category]
      else
        search_offers = "all"
      end
    
      if params[:search_offers].present? && params[:search_offers][:local].present?
        local = params[:search_offers][:local]
      else
        local = ''
      end
      @sorted_offers = Offer.search(search_offers, local, current_user )
      
    end

    def insider_share_page
    end

    def insider_suggestion_drilldown
    end

    def more_shared_deals
      @trackers = Tracker.shared_to_me(current_user, Offer.to_s).order('created_at DESC').offset(1)
    end

    def track_snapped
      offer = Offer.find params[:id]
      if offer.deal_source.match(/groupon/i)
        resultant_url = "http://www.anrdoezrs.net/click-7054643-10804307?url=#{URI::escape(offer.deal_url)}"
      else
        resultant_url = "http://www.dpbolvw.net/click-7054643-11238317?url=#{URI::escape(offer.deal_url)}"
      end
      redirect_to(URI::escape(resultant_url))
      activity = current_user.activities.build
      activity.icon_path = offer.icon_path(current_user.user_profile)
      InsiderActivity.get_snap_track(offer, current_user)
      activity.update_my_activity(offer, "Snapped", "Offer - #{offer.merchant_name}", Offer::Kudos_Pts::Share_Deal)
    end

    def show_all
      @offers = Offer.division_matching_offers(current_user)
    end

    def ignore_offer
      offer = Offer.find_by_id params[:id]
      tracker = Tracker.get_tracker(current_user, Offer.to_s, offer).first if offer.present?
      tracker.destroy if tracker.present?
      redirect_to insider_offers_url
    end

    protected

    def check_for_guide
      if current_user.user_profile.show_insider_guide == true && session[:show_insider].blank?
        redirect_to check_guide_path(:guide_page => 'insider')
      end
    end

  end
end
