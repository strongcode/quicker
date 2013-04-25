class FriendsRequestsController < ApplicationController

  before_filter :authenticate_user!

  def new
    @friend_request = FriendsRequest.new
  end

  def create
    @friend_request = FriendsRequest.new(params[:friends_request])
    if @friend_request.save
      redirect_to new_friends_request_url
    else
      render 'new'
    end
  end

  def autocomplete
    sent_requests = current_user.friend_requests_sent.map(&:friend_to_id)
    received_requests = current_user.friend_requests.map(&:friend_from_id)
    @friends_list = User.non_friends(current_user, (params[:term].presence || ''), sent_requests +received_requests )
    if @friends_list
      @friends_list = @friends_list.sort_by {|user| user.first_name.presence || ''}.compact
      respond_to do |format|
        format.js {render :json => @friends_list.map{|friend| { :id => friend.id,
              :value => friend.display_name, :image => friend.mini_avatar_image, :address => friend.get_address } }}
      end
    else
      render :nothing => true
    end
  end

  def invite
    if params[:sg_user_ids].present?
      FriendsRequest.invite_sg_users(params[:sg_user_ids], current_user)
    end
    redirect_to invite_facebook_friends_path
  end

  
end