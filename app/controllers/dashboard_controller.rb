class DashboardController < ApplicationController
  require 'mustache'

  before_filter :authenticate_user!
  before_filter :get_shares_count, :only => [:my_dashboard]

  def db_status
  end

  def my_dashboard
    month_number = params[:page].to_i.zero? ? 1 : params[:page].to_i
    @friends = current_user.get_friends
    @friend_requests = current_user.friend_requests
    @users = User.fetch_my_friend_requests(@friend_requests.map(&:friend_from_id))
    @offers_presented = current_user.insider_activities.presented
    @offers_snapped = current_user.insider_activities.snapped
    @activities = current_user.activities.non_zero_kudos.page_wise(month_number).order('updated_at DESC')
  end

  def db_activities
    month_number = params[:page].to_i.zero? ? 1 : params[:page].to_i
    @activities = Goal.where(:id => nil).where("id IS NOT ?", nil)

    if params[:activity_type].present?
      if params[:activity_type].include?('all')
        activity_list = ['all']
      else
        activity_list = params[:activity_type]
      end

      activity_list.each do |activity|
        case activity
        when /assistant/i
          @activities = current_user.activities.custom_activities('Goal').page_wise(month_number)
        when /sidekick/i
          @activities = current_user.activities.custom_activities('Location').page_wise(month_number)
          @activities = @activities + current_user.activities.custom_activities('Review').page_wise(month_number)
          @activities = @activities + current_user.activities.custom_activities('LocationList').page_wise(month_number)
          @activities = @activities + current_user.activities.custom_activities('Passionate').page_wise(month_number)
        when /insider/i
          @activities = @activities + Offer.where(:id => nil).where("id IS NOT ?", nil)
        when /profile/i
          @activities = @activities + current_user.activities.custom_activities('UserProfile').page_wise(month_number)
          @activities = @activities + current_user.activities.custom_activities('Friend').page_wise(month_number)
          @activities = @activities + current_user.activities.custom_activities('User').page_wise(month_number)
        else
          @activities = current_user.activities.page_wise(month_number)
        end
      end
    else
      @activities = current_user.activities.page_wise(month_number)
    end
    
    @activities = @activities.order('updated_at DESC')
    respond_to do |format|
      format.html
      format.json { render json: @activities.map { |activity| view_context.activity_for_mustache(activity) } }
    end
  end

  def db_friends
    @friends = @profile_user.get_friends
    @friend_requests = current_user.friend_requests
    @users = User.fetch_my_friend_requests(@friend_requests.map(&:friend_from_id))
  end

  def db_locations

  end


  def db_calendar
    @activities = current_user.goals.where("updated_at != '0000-00-00 00:00:00'") +
      current_user.reviews.where("updated_at != '0000-00-00 00:00:00'") +
      current_user.locations.where("updated_at != '0000-00-00 00:00:00'")
  end

  def db_add_friends
  end

  def db_passionates

  end

  def accept_friend_request
    if params[:friends].present?
      params[:friends].each do |friend_id|
        @friend = Friend.new(:user_id => current_user.id, :friend_id => friend_id)
        friend_request = FriendsRequest.where("friend_to_id = ? AND friend_from_id = ?", current_user.id, friend_id).first
        friend_request.accept
        friend_reverse = Friend.new(:user_id => friend_id, :friend_id => current_user.id)
        if @friend.save && friend_reverse.save
          user = User.find @friend.friend_id
          activity = current_user.activities.build
          activity.icon_path = @friend.icon_path(user.user_profile)
          activity.update_my_activity(@friend)
        end
      end
    end
    @friends = current_user.get_friends
    @friend_requests = current_user.friend_requests
    @users = User.fetch_my_friend_requests(@friend_requests.map(&:friend_from_id))
   
  end

  def archive_friend_request
    if params[:friends].present?
      params[:friends].each do |friend_id|
        friend_request = FriendsRequest.where("friend_to_id = ? AND friend_from_id = ?", current_user.id, friend_id).first
        friend_request.archive
      end
    end
    @friend_requests = current_user.friend_requests
    @users = User.fetch_my_friend_requests(@friend_requests.map(&:friend_from_id))
    
  end

  def delete_friends
    if params[:friends].present?
      friend_ids = params[:friends].map{|friend| friend.to_i}
      friends = current_user.friends.where('friend_id IN(?)', friend_ids)
      current_user_shares = current_user.shares
      current_user_trackers = Tracker.where("user_id IN(?) AND trackable_id IN(?)", friend_ids , current_user_shares.map(&:shareable_id))
      current_user_trackers.destroy_all if current_user_trackers.present?
      
      friends_shares = Share.where("user_id IN(?)", friend_ids)
      friends_trackers = Tracker.where("user_id = ? AND trackable_id IN(?)", current_user.id, friends_shares.map(&:shareable_id))
      friends_trackers.destroy_all if friends_trackers.present?
      friends.destroy_all if friends.present?

      friends = Friend.where("(user_id = ? AND friend_id IN(?)) OR (user_id IN(?) AND friend_id = ?) ", current_user.id, friend_ids, friend_ids, current_user.id)
      friends.destroy_all if friends.present?
    end
    @friends = current_user.get_friends
  end

  ## Used to send invitation to facebook friends
  def invite_facebook_friends
  end

  def facebook_friends
    @snapgadget_users, @facebook_friends = User.get_fb_friends_and_sg_user(params[:data], current_user)
  end

  protected
  
  def get_shares_count
    @trackers = current_user.trackers.get_trackers_since_lda(current_user)
    current_user.lda = Time.now
    current_user.save
  end
  
end
