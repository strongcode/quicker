class RegistrationsController < Devise::RegistrationsController

  def new
    session[:new_user_profile_record] = true
    super
  end

  def create
    build_resource
    resource.pioneer_flag = 1

    if resource.save
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_up(resource_name, resource)
        respond_with resource, :location => after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      respond_with resource
    end

  end

  def edit
    @photo = @profile_user.photo || @profile_user.build_photo
    super
  end

  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    if resource.update_attributes(resource_params)
      if resource.unconfirmed_email?
        flash[:notice] = "You will receive an email to your updated Email ID, with instructions about how to confirm your new Email in a few minutes. Please confirm your Email before continuing."
      else
        flash[:notice] = "Your Profile is successfully Updated."
      end
      sign_in resource_name, resource, :bypass => true
      respond_with resource, :location => after_update_path_for(resource)
    else
      clean_up_passwords resource
      respond_with resource
    end
  end

  protected

  def after_sign_up_path_for(resource)
    session[:show_sidekick_help_guide] = "true"
    session[:show_assistant_help_guide] = "true"
    session[:show_insider_help_guide] = "true"
    session[:show_dashboard_help_guide] = "true"
    resource.set_membership_status
    resource.develop_user_profile(params[:user_profile])
    resource.default_landing_page
  end

  def sign_up(resource_name, resource)
    sign_in(resource_name, resource)
  end

end
