module Sidekick
  class LocationsController < ApplicationController
    before_filter :authenticate_user!

    def new
      @categories = Category.where("major_category like '%lifestyle%' AND minor_category NOT like '%lifestyle%'")
      @location = current_user.locations.build
      @review = @location.build_review
      @photo = @review.photos.build
    end
    
    def create
      @categories = Category.where("major_category like '%lifestyle%' AND minor_category NOT like '%lifestyle%'")
      @location_list = LocationList.find_by_id params[:location_list_id]
      @location = current_user.locations.build(params[:location])
      @location.review.user = current_user
      respond_to do |format|
        format.html do
          if @location.save
            if @location_list.present?
              redirect_to update_list_sidekick_location_list_path(@location_list, :location_id => @location.id)
            else
              redirect_to new_sidekick_location_list_path(:location_id => @location.id)
            end
          else
            render 'new_location'
          end
        end
      end
      
    end

    def show_my
      @location_list = LocationList.find_by_id params[:location_list_id].to_i
      @location_list.destroy if @location_list.present? && @location_list.locations.blank?
      if @location_list.present? && !@location_list.destroyed?
        @status = true
        @friends = Tracker.non_shared_friends(@location_list, current_user)
        @locations = @location_list.locations.scoped
        @passionate_location = current_user.passionate.present? && current_user.passionate.location.present? ? (current_user.passionate.location) : (nil)
        @suggestion_locations = current_user.suggestions.present? ? current_user.suggestions.map(&:location_id) : ([])
        @suggestion_locations = current_user.suggestions.present? ? current_user.suggestions.map(&:location_id) : ([])
        @share = @location_list.shares.last if @location_list.shares.present?
        @list_tracker = Tracker.get_tracker(current_user, LocationList.to_s, @location_list)
        major_category_wise_locations(@locations)

        session[:location_list_id] = params[:location_list_id]
      else
        @status = false #If no location list found, redirect to sidekick main page.
      end
    end

    def get_minor_category
      if params[:location][:sg_major_category].present?
        @categories = Category.where("major_category like '%#{params[:location][:sg_major_category].split[0]}%' AND major_category != minor_category")
        main_category = Category.where("major_category like '%#{params[:location][:sg_major_category].split[0]}%' AND major_category = minor_category")
        @categories = @categories.sort_by {|category| category.description}
        @categories = main_category + @categories
      end
    end

    def archive
      @location = current_user.locations.find params[:id]
      @location_list = current_user.location_lists.where("id = ?", params[:location_list_id]).first
      if @location.present?
        @location.archive
        @location.save
      end
      respond_to do |format|
        format.html {redirect_to sidekick_url(:location_list_id => @location_list.id)}
        format.js {}
      end

    end

    private
    
    def major_category_wise_locations(locations)
      @lifestyle_locations = locations.lifestyle_locations
      @shopping_locations = locations.shopping_locations
      @food_locations = locations.food_locations
      @travel_locations = locations.travel_locations
      @business_locations = locations.business_locations
      @all_locations = [@lifestyle_locations, @shopping_locations, @food_locations,
        @travel_locations, @business_locations ]
    end
        
  end
end





