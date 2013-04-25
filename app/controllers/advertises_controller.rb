class AdvertisesController < ApplicationController
  def new
    @advertise = Advertise.new
  end
  def create
    @advertise = Advertise.new(params[:advertise])
    if @advertise.save
      Notifier.advertise(@advertise).deliver
      if user_signed_in?
        redirect_to current_user.default_landing_page
      else
        redirect_to root_url
      end
    else
      render 'new'
    end
  end
end
