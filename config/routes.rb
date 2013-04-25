SnapGadget::Application.routes.draw do
  if Rails.env.production?
    match '/send-invitation-email' => 'home#send_invitation_email', :as => :send_invitation_email
    root :to => 'home#launch'
  else
    get "preference/pref_page"

    devise_for :admins, :controllers => {
      :sessions => 'admins/sessions',
      :registrations => 'admins/registrations'
    }
    
    devise_for :users, :path => 'members', :controllers => {
      :sessions => 'sessions',
      :registrations => 'registrations',
      :confirmations => 'confirmations',
      :omniauth_callbacks => 'users/omniauth_callbacks'
    }
    resources :users, :only => [] do
      member do
        get 'edit_password'
        put 'update_password'
        get 'reviewer'
        post :check
      end
    end

    resource :user_profile, :except => [:destroy, :show] do
      collection do
        get 'reset'
        post 'customize_avatar'
        post 'update_questions'
        get 'adv_preference'
      end
    end
    resource :user_preference, :except => [:destroy, :show]

    match '/send-invitation-email' => 'home#send_invitation_email', :as => :send_invitation_email
    match '/launch' => 'home#launch', :as => :launch
    match '/spread-the-word' => 'home#spread_the_word', :as => :spread_the_word
    match '/dummy/' => 'home#dummy_iframe', :as => :dummy
    match '/list' => 'home#list', :as => :list
    match '/privacy' => 'home#privacy', :as => :privacy
    match '/terms' => 'home#terms_of_use', :as => :terms_of_use
    match '/FAQ' => 'home#faq', :as => :faq
    match '/about_us' => 'home#about_us', :as => :about_us
    match '/contact_us' => 'contacts#new', :as => :contact_us
    match '/help' => 'home#help', :as => :help
    match '/advertise' => 'advertises#new', :as => :advertise
    match '/sign_up/privacy' => 'home#tmp', :as => :tmp
    match '/sign_up/terms_of_use' => 'home#tep', :as => :tep
    match '/sign_up/about' => 'home#tpm', :as => :tpm
    match '/about' => 'home#temp', :as => :about
    match '/dashboard' => 'home#dashboard', :as => :dashboard
    match 'link-social-media' => 'users#link_social_media', :as => :link_social_media
    match 'social-medias' => 'users#social_medias', :as => :social_media
    match '/invitation' => 'home#invitation'
    match '/send-invitation-email' => 'home#send_invitation_email', :as => :send_invitation_email
    match 'photo-save' => 'user_profiles#photo_save', :as => :photo_save
    match '/db_status' => 'dashboard#db_status', :as => :db_status
    match '/db_activities' => 'dashboard#db_activities', :as => :db_activities
    match '/db_friends' => 'dashboard#db_friends', :as => :db_friends
    match '/db_locations' => 'dashboard#db_locations', :as => :db_locations
    match '/db_calendar' => 'dashboard#db_calendar', :as => :db_calendar
    match '/db_passionates' => 'dashboard#db_passionates', :as => :db_passionates
    match '/db_add_friends' => 'dashboard#db_add_friends', :as => :db_add_friends
    match '/my_dashboard' => 'dashboard#my_dashboard', :as => :my_dashboard

    match 'sidekick' => 'sidekick/interface#main', :as => :sidekick
    match 'sidekick/check' => 'sidekick/interface#check', :as => :check, :via => :post

    match 'autocomplete' => 'friends_requests#autocomplete', :as => :autocomplete
    match 'accept' => 'dashboard#accept_friend_request', :as => :accept
    match 'archive' => 'dashboard#archive_friend_request', :as => :archive
    match 'sg-categories' => 'user_profiles#sg_categories', :as => :sg_category
    match 'sg_suggestions' => 'user_profiles#sg_suggestions', :as => :sg_suggestion
    match 'sg_deserve_it' => 'user_profiles#sg_deserve_it', :as => :sg_deserve_it
    match 'category-save' => 'user_profiles#category_save', :as => :category_save
    match 'suggestion-save' => 'user_profiles#suggestion_save', :as => :suggestion_save
    match 'deserve-it-save' => 'user_profiles#u_deserve_it_save', :as => :u_deserve_it_save
    match 'photo-cancel' => 'user_profiles#photo_cancel', :as => :photo_cancel
    match 'minor-category' => 'sidekick/locations#get_minor_category', :as => :minor_category
    match 'insider_do_better' => 'insider/offers#insider_do_better', :as => :insider_do_better
    match 'insider_search' => 'insider/offers#insider_search', :as => :insider_search
    match 'insider_share_page' => 'insider/offers#insider_share_page', :as => :insider_share_page
    match 'insider_suggestion_drilldown' => 'insider/offers#insider_suggestion_drilldown', :as => :insider_suggestion_drilldown
    match 'update_minor_categories' => 'insider/offers#update_minor_categories', :as => :update_minor_categories
    match 'delete-friends' => 'dashboard#delete_friends', :as => :delete_friends
    match 'check-guide' => 'home#check_guide', :as => :check_guide
    match 'save_guide_setting' => 'home#save_guide_setting', :as => :save_guide_setting
    match 'curious_reviews' => 'sidekick/reviews#curious_reviews', :as => :curious_reviews
    match 'invite-friends' => 'dashboard#invite_facebook_friends', :as => :invite_facebook_friends
    match 'facebook-friends' => 'dashboard#facebook_friends', :as => :facebook_friends

    match 'admin' => 'admins/activities#list', :as => :admin
   
    namespace :sidekick do
      resources :locations, :only => [:new, :create] do
        collection do
          post :show_my
          get :get_minor_category
        end
        member do
          get :archive
        end
        resource :review, :except => [:destroy] do
          member do
            get :details
          end
        end
      end

      resources :location_lists, :only => [:new, :create, :update] do
        member do
          get :update_list
        end
        resources :shares, :only => [:new, :create]
      end

      resource :passionate, :except => [:show] do
        resources :passionate_shares, :only => [:new, :create]
        collection do
          post 'check'
          post 'location_create'
        end
      end
      resources :trackers, :only => [:destroy]

    end

    namespace :list do
      
      resources :locations
      resources :location_lists, :only => [:new, :create, :index, :destroy, :update] do
        collection do
          get :friends, :new_loc_list
          get :reload_window
          get :list_name
          post :create_or_add_location
          post :check
        end
        member do
          get :delete_location
          get :new_location
          delete :ignore
          post :update_list
          post :add_location
          delete :remove_location
        end

        resources :shares, :only => [:new, :create]
      end
      
    end

    #match 'insider' => 'home#sidekick', :as => :insider

    namespace :assistant do
      resources :trackers, :only => [:destroy]
      resources :goals do
        resources :shares, :only => [:new, :create]
      end
    end

    namespace :insider do

      resources :offers, :only => [:index] do
        collection do
          get :more_shared_deals
        end
        member do
          get 'track_snapped'
          get :ignore_offer
        end
        resources :shares, :only => [:new, :create]
      end

      resources :suggestions, :except => [:show] do
        resources :suggestion_shares, :only => [:new, :create]
        collection do
          post 'location_create'
          post 'check'
          get 'get_minor_category'
          get :more_shared_suggestions
          get :more_friends_suggestions
          get :more_mine_suggestions
        end
      end
      
    end

    resources :friends_requests, :only => [:new, :create] do
      collection do
        post :invite
      end
    end

    resource :user_question, :except => [:show, :destroy] do
    end

    resources :contacts 
    resources :advertises
    
    #smatch 'populate-location' => 'sidekick#populate_location', :as => :populate_location

    #match 'bounded-locations' => 'sidekick#get_bounded_locations', :as => :get_bounded_locations
    # The priority is based upon order of creation:
    # first created -> highest priority.

    root :to => 'home#welcome'
  end

end
