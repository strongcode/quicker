module Insider
  class SuggestionsController < InheritedResources::Base
    InheritedResources.flash_keys = [:success, :failure]
    before_filter :authenticate_user!
    skip_before_filter :check_for_user_profile, :only => [:get_minor_category]
    
    actions :all, :except => [:show]
    respond_to :html, :except => [:except]
    respond_to :js, :except => [:except]
    defaults :route_prefix => 'insider'

    def new
      @categories = Category.where("major_category like '%lifestyle%' AND minor_category NOT like '%lifestyle%'")
      @suggestion = current_user.suggestions.build
      @photo = @suggestion.photos.build
    end

    def create
      @categories = Category.where("major_category like '%lifestyle%' AND minor_category NOT like '%lifestyle%'")
      @suggestion = current_user.suggestions.build(params[:suggestion])
      if @suggestion.save
        respond_to do |format|
          format.html { redirect_to insider_offers_url}
          format.js {}
        end
      else
        respond_to do |format|
          format.html { render 'new'}
          format.js {}
        end
      end
    end

    def edit
      @suggestion = current_user.suggestions.find params[:id]
      @category = Category.find_by_id @suggestion.snapgadget_category_id
      @categories = Category.where("major_category like ?", @category.major_category )
      #edit!
    end

    def update
      @categories = Category.where("major_category like '%lifestyle%' AND minor_category NOT like '%lifestyle%'")
      update! do |success, failure|
        success.html {redirect_to @suggestion.location.present? ? sidekick_url(:iframe => 1, :location_id => @suggestion.location.id) : (sidekick_url)}
        failure.html { render 'new'}
      end
    end

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

    def get_minor_category
      if params[:sg_major_category].present?
        @categories = Category.where("major_category like '%#{params[:sg_major_category].split[0]}%' AND major_category != minor_category")
        main_category = Category.where("major_category like '%#{params[:sg_major_category].split[0]}%' AND major_category = minor_category")
        @categories = @categories.sort_by {|category| category.description}
        @categories = main_category + @categories
      end
    end

    def more_shared_suggestions
      @trackers = Tracker.shared_to_me(current_user, Suggestion.to_s).order('created_at DESC').offset(1)
    end
    
    def more_friends_suggestions
      @friends_suggestions = Suggestion.friends_suggestions(current_user).offset(1)
    end

    def more_mine_suggestions
      @suggestions = Suggestion.all_except_friends_suggestions(current_user).offset(1)
    end


    protected

    def begin_of_association_chain
      current_user
    end

  end
  
end
