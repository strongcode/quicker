class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def self.provides_callback_for(*providers)
    providers.each do |provider|
      class_eval %Q{
        def #{provider}
          logger.info "*********"
            logger.info env["omniauth.auth"]
          logger.info "*********"
          @user, status = User.find_or_create_for_#{provider} env["omniauth.auth"]
          sign_in @user
          redirect_to status ? (edit_user_profile_url(:step => 'new')) : (root_url)
        end
      }
    end
  end

  provides_callback_for :facebook, :twitter, :linkedin, :google_oauth2
end
