module Sidekick
  class LocationListsController < ApplicationController
    before_filter :authenticate_user!

    def new
      @location_lists = current_user.location_lists
      @friends_location_lists = LocationList.shared_location_lists(current_user)
      @all_location_lists = @location_lists + @friends_location_lists
      @location_list = current_user.location_lists.build
    end

    def create
      @location = Location.find_by_id params[:location_id]
      @location_list = current_user.location_lists.build
      if params[:location_list].present? && params[:location_list][:name].present?
        @location_list.name = params[:location_list][:name]
      elsif params[:location_list_id].present?
        @location_list = LocationList.find_by_id params[:location_list_id]
      end
      @new_list = @location_list.add_location_and_clone_list(current_user, @location)
      if @new_list.save
        @location_list.remove_tracker(current_user)
        redirect_to sidekick_path(:location_list_id => @new_list.id)
      else
        @location_lists = current_user.location_lists
        @friends_location_lists = LocationList.shared_location_lists(current_user)
        @all_location_lists = @location_lists + @friends_location_lists
        render 'new'
      end
      
    end


    def update_list
      begin
        @location_list = LocationList.find_by_id params[:id]
        @location = Location.find_by_id params[:location_id]
        @new_list = @location_list.add_location_and_clone_list(current_user, @location)
        respond_to do |format|
          if @new_list.save
            @location_list.remove_tracker(current_user)
            format.html {redirect_to sidekick_path(:location_list_id => @new_list.id)}
            format.js {}
          else
            format.html {redirect_to sidekick_path}
            format.js {}
          end
        end
      rescue
        redirect_to sidekick_path
      end
    end
    
  end

end