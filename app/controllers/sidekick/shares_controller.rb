module Sidekick
  class SharesController < InheritedResources::Base
    before_filter :authenticate_user!
    actions :all, :only => [:new, :create]
    respond_to :html
    layout 'new_fancybox', :except => [ :show, :create]

    def new
      @location_list = LocationList.find(params[:location_list_id])
      @friends = Tracker.non_shared_friends(@location_list, current_user)
      @share = current_user.shares.build
      session[:location_list_id] = @location_list.id
      session[:referer] = request.referer
    end

    def create
      create! do  |success, failure |
        success.html do
          @referer = session[:referer]
          session[:referer] = nil
          redirect_to @referer || list_location_lists_url(:location_list_id => @location_list.id)
        end
        failure.html do
          @friends = Tracker.non_shared_friends(@location_list, current_user)
          render 'new'
        end
      end
    end

    private
    def begin_of_association_chain
      @location_list = LocationList.find(params[:location_list_id])
    end
  end
end