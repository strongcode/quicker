class List::LocationsController < ApplicationController

  before_filter :authenticate_user!

  def new
    @categories = Category.where("major_category like '%lifestyle%' AND minor_category NOT like '%lifestyle%'")
    @location = current_user.locations.build(params[:location])
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
          list_id = @location_list.present? ? (@location_list.id) : (0)
          list_name = @location_list.present? ? (@location_list.name) : (params[:location_list_name])
          @new_list = LocationList.find_location_list_and_populate_with_location(current_user, list_id, @location, list_name)
          if @new_list.save
            @location_list.remove_tracker(current_user) if @location_list.present?
            redirect_to list_location_lists_url(:location_list_id => @new_list.id)
          else
            redirect_to new_list_location_list_path
          end
        else
          render 'new'
        end
      end
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
end
