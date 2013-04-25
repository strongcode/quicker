module Sidekick
  class ReviewsController < ApplicationController

    before_filter :authenticate_user!

    def new
      @location = Location.find_by_id params[:location_id]
      @review = @location.reviews.build
    end

    def create
      location = Location.find_by_id params[:location_id]
      @location_list = LocationList.find_by_id params[:location_list_id]
      if current_user.locations.include?(location)
        @review = location.build_review(params[:review])
        @review.user_id = current_user.id
      else
        @new_location = location.clone_location(current_user)
        if @new_location.save
          @review = @new_location.build_review(params[:review])
          @review.user_id = current_user.id
        end
      end
      
      if @review.save
        respond_to do |format|
          format.html {redirect_to sidekick_url(:location_list_id => params[:location_list_id]) }
          format.js {}
        end
      else
        respond_to do |format|
          format.html {render 'new'}
          format.js {}
        end
      end
    end

    def show
      @review = Review.find_by_id params[:review_id]
    end

    def edit
      @location = Location.find params[:location_id]
      @location_list = LocationList.find_by_id params[:location_list_id]
      @review = @location.reviews.find params[:id]
    end

    def update
      @location = Location.find params[:location_id]
      @review = @location.review
      begin
        if @review.present? && (@review.update_attributes params[:review])
          @location_picture = @location.default_image(current_user)
          respond_to do |format|
            format.html {redirect_to sidekick_url(:location_list_id => params[:location_list_id]) }
            format.js {}
          end
        else
          location_reviews = Review.location_reviews(@location)
          @my_review = location_reviews.my_review(current_user)
          @friends_reviews = location_reviews.friends_reviews(current_user)
          @my_and_friends_reviews = location_reviews.my_and_friends_reviews(current_user)
          @snapgadget_reviews = location_reviews.snapgadget_reviews(current_user)
          @all_reviews = [@my_review, @friends_reviews, @snapgadget_reviews]
          respond_to do |format|
            format.html {render 'index'}
            format.js {}
          end
        
        end
      rescue
        redirect_to sidekick_location_reviews_url(@location)
      end
    end

    def details
      @location = Location.find_by_id params[:location_id]
      @location_list = LocationList.find_by_id params[:location_list_id]

      location_reviews = Review.location_reviews(@location)
      @review = location_reviews.my_review(current_user).first

      if @review.blank?
        @review = current_user.reviews.build
      end

      @popular_locations = LocationList.popular_locations(@location)
        
      @friends_reviews = location_reviews.friends_reviews(current_user)
      @my_and_friends_reviews = location_reviews.my_and_friends_reviews(current_user)
      @snapgadget_reviews = location_reviews.snapgadget_reviews(current_user)
      @all_reviews = [@friends_reviews, @snapgadget_reviews]
      @passionates = Passionate.passionate_count(@location)
      @location.location_images(current_user, Passionate.to_s)
    end

    def curious_reviews
      @location = Location.find_by_id params[:location_id]
      @all_reviews = []
      if @location.present?
        @popular_locations = LocationList.popular_locations(@location)
        session[:location_id] = @location.id
        location_reviews = Review.location_reviews(@location)

        @friends_reviews = location_reviews.friends_reviews(current_user)
        @my_and_friends_reviews = location_reviews.my_and_friends_reviews(current_user)
        @snapgadget_reviews = location_reviews.snapgadget_reviews(current_user)
        @all_reviews = [@friends_reviews, @snapgadget_reviews]

        @location.location_images(current_user, Passionate.to_s)
      end
      
    end
      
  end
end
