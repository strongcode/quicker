module Insider
  class SharesController < InheritedResources::Base
    InheritedResources.flash_keys = [ :success, :failure ]
    before_filter :authenticate_user!
    actions :all, :only => [:new, :create]
    respond_to :html, :js
    defaults :route_prefix => 'insider'

    def new
      @offer = Offer.find(params[:offer_id])
      @share = current_user.shares.build
      @friends = Tracker.non_shared_friends(@offer, current_user)
    end

    def create
      create! do  |success, failure |
        success.html {redirect_to insider_offers_path}
        failure.js {@friends = Tracker.non_shared_friends(@offer, current_user)}
        failure.html do
          @friends = Tracker.non_shared_friends(@offer, current_user)
          render 'new'
        end
      end
    end

    private
    def begin_of_association_chain
      @offer = Offer.find(params[:offer_id])
    end
  end
end