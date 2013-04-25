class SessionsController < Devise::SessionsController

  after_filter :destroy_sessions, :only => [:destroy]
  # POST /resource/sign_in
  def create
    resource = warden.authenticate!(auth_options)
    set_flash_message(:notice, :signed_in) if is_navigational_format?
    cookies[:email] = {:value => params[:user] && params[:user][:sg_remember_me] ? params[:user][:email] : nil, :expires => 2.weeks.from_now}
    sign_in(resource_name, resource)

    respond_to do |format|
      format.html do
        respond_with resource, :location => after_sign_in_path_for(resource)
      end
      format.json do
        render :json => {:response => 'ok', :auth_token => current_user.authentication_token}.to_json, :status => :ok
      end
    end
  end


  #"curl -X POST 'http://localhost:3000/members/sign_in.json' -d 'user[email]=raghugjoshi123@gmail.com&user[password]=123456'"
  protected

  def after_sign_in_path_for(resource)
    session[:show_sidekick_help_guide] = "true"
    session[:show_assistant_help_guide] = "true"
    session[:show_insider_help_guide] = "true"
    session[:show_dashboard_help_guide] = "true"
    session[:location_list_id] = nil
    current_user.default_landing_page
  end

  def destroy_sessions
    session[:trail] = nil
    session[:show_sidekick_help_guide] = nil
    session[:show_assistant_help_guide] = nil
    session[:show_insider_help_guide] = nil
    session[:show_dashboard_help_guide] = nil
    session[:location_list_id] = nil
  end
  
end