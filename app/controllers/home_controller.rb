class HomeController < ApplicationController
  layout :choose_layout
  before_filter :check_default_langing_page, :only => [:welcome]
  
  def list
    @users = User.all
  end

  def facebook
    @auth = env["omniauth.auth"]
  end

  def invitation
    render :layout => false
  end

  def welcome
  end

  def check_guide
    params[:guide_page]
  end

  def save_guide_setting
    case params[:guide_page]
    when "sidekick"
      current_user.user_profile.show_sidekick_guide = params[:user_profile].present? ? (false) : (true)
      session[:show_sidekick_help_guide] = nil
    when "insider"
      current_user.user_profile.show_insider_guide = params[:user_profile].present? ? (false) : (true)
      session[:show_insider_help_guide] = nil
    when "assistant"
      current_user.user_profile.show_assistant_guide = params[:user_profile].present? ? (false) : (true)
      session[:show_assistant_help_guide] = nil
    when "dashboard"
      current_user.user_profile.show_dashboard_guide = params[:user_profile].present? ? (false) : (true)
      session[:show_dashboard_help_guide] = nil
    end
    current_user.user_profile.save
  end

  def send_invitation_email
    Notifier.request_intimation(params[:user][:email]).deliver
    Notifier.adminstrator(params[:user][:email], request.remote_ip, params[:user][:city], params[:user][:region_name]).deliver
  end

  def dummy_iframe
    redirect_to params[:target_path]
  end

  private

  def check_default_langing_page
    if user_signed_in?
      redirect_to current_user.default_landing_page
    end
  end

  protected

  def choose_layout
    params[:action] == 'launch' ? ("launch_page") : ("application")
  end

end
