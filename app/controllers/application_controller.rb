class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_current_user, :set_locale, :except => [:destroy]

  before_filter :check_for_user_profile, :except => [:destroy, :about_us, :privacy, :terms_of_use, :faq,:contact_us,:advertise]
  after_filter :set_access_control_header


  private
  def set_current_user
    if user_signed_in?
      @user = current_user
      @profile_user = User.find @user.id
      @user_profile = current_user.user_profile
    end
  end

  def set_locale
    I18n.locale = user_signed_in? && @user.user_profile.present? ? @user.user_profile.locale : I18n.default_locale
  end

  def check_for_user_profile
    if user_signed_in?
      if current_user.user_profile.blank? 
        redirect_to new_user_profile_url
      end
    end
    
  end

  protected

  def set_access_control_header
    headers['Access-Control-Allow-Origin'] = configatron.site_address_full
    headers['Access-Control-Allow-Methods'] = '*'
  end


  #  def check_for_user_preference
  #    if user_signed_in? && @user.user_profile.present?
  #      if @user.user_preference.blank?
  #        redirect_to new_user_preference_url
  #      else
  #        @user_preference = current_user.user_preference
  #      end
  #    end
  #
  #  end

end
