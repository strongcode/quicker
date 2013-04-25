module Sidekick
  class PassionatesController < ApplicationController

    before_filter :authenticate_user!
    before_filter :store_id_session, :only => [:update, :create]
    skip_before_filter :check_for_user_profile

    def new
      if current_user.passionate.present?
        redirect_to edit_sidekick_passionate_url
        return
      end
      @passionate = current_user.build_passionate
      @photo = @passionate.build_photo
      category = Category.where("major_category like '%lifestyle%' AND minor_category like '%lifestyle%'").first
      get_categories(category)
    end

    def create
      @passionate = current_user.build_passionate(params[:passionate])
      respond_to do |format|
        if @passionate.save
          format.html {redirect_to edit_user_profile_path}
          format.js {}
        else
          category = Category.where("major_category like '%business%' AND minor_category like '%business%'").first
          get_categories(category)
          format.html {render 'new'}
          format.js {}
        end
      end
    end

    def edit
      if current_user.passionate.blank?
        redirect_to new_passionate_url
        return
      end
      @passionate = current_user.passionate
      @photo = @passionate.photo
      @category = Category.find_by_id @passionate.snapgadget_category_id
      get_categories(@category)
    end

    def update
      @passionate = current_user.passionate
      if @passionate.update_attributes(params[:passionate])
        respond_to do |format|
          format.html {redirect_to edit_user_profile_path}
          format.js {}
        end
      
      else
        @category = Category.find_by_id @passionate.snapgadget_category_id
        get_categories(@category)
        respond_to do |format|
          format.html  {render 'edit'}
          format.js {}
        end
      end
    end

    def destroy
      @passionate = current_user.passionate
      @passionate.destroy
      redirect_to edit_user_profile_path
    end

#    def index
#      @trackers = current_user.trackers.passionates
#    end

    def check
      @location = Location.check_for_location(params[:location], current_user)
    end

    def location_create
      @location = current_user.locations.build(params[:location])
      if params[:category_id].present?
        category = Category.find_by_id params[:category_id]
        @location.sg_major_category = category.major_category
        @location.sg_minor_category = category.minor_category.downcase.strip
      end
      @location.save
    end

    #
    #def location_list
    #  @locations = Location.search(params[:term].presence || '')
    #  @locations = @locations.sort_by { |location| location.name.presence || '' }.compact
    #  if @locations
    #    respond_to do |format|
    #      format.js { render :json => @locations.map { |location| {:id => location.id, :value => location.name} } }
    #    end
    #  else
    #    render :nothing => true
    #  end

    protected
  
    def store_id_session
      session[:passionate_id] = params[:id]
    end

    def get_categories(category)
      @categories = Category.where("major_category like '%#{category.major_category.split[0]}%' AND major_category != minor_category")
      main_category = Category.where("major_category like '%#{category.major_category.split[0]}%' AND major_category = minor_category")
      @categories = @categories.sort_by {|category| category.description}
      @categories = main_category + @categories
    end
  end
end