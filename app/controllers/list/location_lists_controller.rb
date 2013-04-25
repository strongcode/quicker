module List
  class LocationListsController < ApplicationController
    before_filter :authenticate_user!
    #before_filter :store_id_session, :only => [:remove_location]

    before_filter :authenticate_user!

    def check
      @location = Location.check_for_location(params[:location], current_user)
      @location_list = LocationList.find_by_id params[:location_list_id]
      session[:location_name] = params[:location][:name]
      session[:location_woeid] = params[:location][:WOEID]
      session[:location_street_address] = params[:location][:street_address]
      session[:location_full_address] = params[:location][:full_address]
      session[:location_latitude] = params[:location][:latitude]
      session[:location_longitude] = params[:location][:longitude]
      session[:location_city] = params[:location][:city]
      session[:location_state] = params[:location][:state]
      session[:location_list_name] = params[:location_list_name]
    end

    def index
      @categories = Category.where("major_category like '%business%' AND minor_category NOT like '%business%'")
      @location_lists = current_user.location_lists + LocationList.shared_location_lists(current_user)
      @location_lists = @location_lists.sort_by {|location_list| location_list.created_at}.reverse
    end

    def new
      @location_list = current_user.location_lists.build
    end

    def create
      @location_list = @profile_user.location_lists.build(params[:location_list])
      location_ids = params[:location_id].present? ? (params[:location_id].uniq):([])
      @location_list.locations = Location.find location_ids
      if @location_list.save
        respond_to do |format|
          format.html {redirect_to list_location_lists_url(:location_list_id => @location_list.id)}
          format.js {@success = true}
        end
      else
        @categories = Category.where("major_category like '%business%' AND minor_category NOT like '%business%'")
        respond_to do |format|
          format.html {render 'new'}
          format.js {@success = false}
        end
      end
    end

    def remove_location
      @location_list = LocationList.find(params[:id])
      @location = Location.find params[:location_id]
      if @location_list.user == current_user
        @location_list.destroy if @location_list.locations.count == LocationList::Minimum_Locations_Count
        # Check if location is present on any other list
        @location_list_ids = LocationLinkedLocList.check_location_in_list(@location_list, @location)
        @location.destroy if @location_list_ids.blank?
      end
      
      respond_to do |format|
        if @location.destroyed? && @location_list.destroyed?
          format.html {redirect_to list_location_lists_path }
          format.js {@status = 2}
        else
          @new_list = @location_list.remove_location_and_clone_list(@location, current_user)
          if @new_list.save!
            @location_list.remove_tracker(current_user)
            format.html {redirect_to list_location_lists_path(:location_list_id => @new_list.id)}
            format.js {@status = 1}
          else
            format.html {redirect_to list_location_lists_path }
            format.js {@status = 2}
          end
        end
      end
      
    end

    def destroy
      @location_list = current_user.location_lists.find params[:id]
      @list_locations = @location_list.locations.map(&:id).sort
      common_location_ids = LocationLinkedLocList.check_location_list_for_locations(@location_list).
        map(&:location_id)
      @remaining_location_ids = (@list_locations - common_location_ids).compact.sort
      @locations = Location.where("id IN(?)", @remaining_location_ids)
      @locations.destroy_all
      @location_list.destroy
      respond_to do |format|
        format.html {redirect_to list_location_lists_url}
        format.js {}
      end
    end

    def ignore
      location_list = LocationList.find_by_id params[:id]
      location_list.remove_tracker(current_user)
      redirect_to list_location_lists_url
    end

    def update
      location_list = LocationList.find_by_id params[:id]
      location = Location.find_by_id params[:location_id]
      @trackers = location_list.trackers.my_tracker(current_user)
      location_name = params[:location_list].present? && params[:location_list][:name].present? ? (params[:location_list][:name]) : (location_list.name)
      respond_to do |format|
        @new_list = location_list.add_location_and_clone_list(current_user, location, location_name)
        if @new_list.save
          location_list.remove_tracker(current_user)
          format.html {redirect_to list_location_lists_url(:location_list_id => @new_list.id)}
          format.js {}
        else
          @categories = Category.where("major_category like '%business%' AND minor_category NOT like '%business%'")
          @location_lists = current_user.location_lists + LocationList.shared_location_lists(current_user)
          format.html {render 'index'}
          format.js {}
        end
      end
      session[:location_list_id] = @new_list.id
    end

  end
end
