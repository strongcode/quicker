class UsersController < ApplicationController

  before_filter :authenticate_user!
  skip_before_filter :check_for_user_profile

  def edit_password
  end

  def update_password
    if @profile_user.update_with_password(params[:user])
      sign_in @profile_user, :bypass => true
      redirect_to edit_user_profile_url
      Notifier.update_password(@profile_user, request.remote_ip).deliver
    else
      render 'edit_password'
    end
  end

  def social_medias
    @social_medias = SocialMedia.all
    render :layout => false
  end

  def link_social_media
    @profile_user.social_medias = SocialMedia.where("social_media_id IN (?)", params[:social_media_id])
    @remaining_social_medias = SocialMedia.all - @profile_user.social_medias
  end

  def reviewer
    @reviewer = User.find params[:id]
    @reviews = @reviewer.reviews.with_comment
  end

  def check
    @location = Location.check_for_location(params[:location], current_user)
  end
  
end
