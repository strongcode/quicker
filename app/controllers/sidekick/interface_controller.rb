module Sidekick
  class InterfaceController < ApplicationController
    before_filter :authenticate_user!

    def main
      if params[:iframe].present? && session[:location_list_id].present?
        list_id = session[:location_list_id]
        session[:location_list_id] = nil
        redirect_to sidekick_path(:location_list_id => list_id)
        return
      end
      @location_list = LocationList.find_by_id params[:location_list_id]
      @location_lists = current_user.location_lists
      @friends_location_lists = LocationList.shared_location_lists(current_user)
      @all_location_lists = (@location_lists + @friends_location_lists + [@location_list]).compact.uniq
      @reviewer_of_the_day = User.reviewer_of_the_day(current_user)
      session[:trail] = 'sidekick'
      @loc_list = ''
    end

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
    end
    
  end
  
end
