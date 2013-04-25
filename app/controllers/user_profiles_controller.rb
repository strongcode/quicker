class UserProfilesController < ApplicationController

  before_filter :authenticate_user!, :get_not_connected_social_medias
  skip_before_filter :check_for_user_profile

  def new
    if @user.user_profile.present?
      redirect_to edit_user_profile_url
      return
    end
    @user_profile = @user.build_user_profile
    @photo = @user_profile.build_photo
    get_preference_completeness
    slider_order_completeness
    get_categories_and_deserve_it(@user_profile)
  end

  def create
    @user_profile = current_user.user_profile.present? ? (current_user.user_profile) : (current_user.build_user_profile)
    @user_profile.attributes = params[:user_profile]
    @user.email = params[:user][:email]
    @user.first_name = params[:user_profile][:first_name]
    @user.last_name = params[:user_profile][:last_name]
    @user_profile.populate_locale
    #@user_profile.update_zipcode
    if @user.save && @user_profile.save
      redirect_to current_user.default_landing_page
    else
      get_preference_completeness
      slider_order_completeness
      get_categories_and_deserve_it(@user_profile)
    end
    
  end

  def edit
    @status = params[:step]
    @user_profile = current_user.user_profile
    unless @user_profile.present?
      redirect_to new_user_profile_url
      return
    end
    @photo = @user_profile.photo.presence || @user_profile.build_photo
    get_preference_completeness
    slider_order_completeness
    get_categories_and_deserve_it(@user_profile)
  end
  

  def update
    # raise params.to_yaml
    @user_profile = current_user.user_profile
    @user_profile.adv_pref_flag = 1 if params[:adv_pref_save] == "1"
    @user_profile.category_flag = 1 if params[:category_flag] == "1"
    
    @user.email = params[:user][:email]
    @user.first_name = params[:user_profile][:first_name]
    @user.last_name = params[:user_profile][:last_name]

    @user_profile.attributes = params[:user_profile]
    @user_profile.populate_locale
    #@user_profile.update_zipcode
    if @user.save && @user_profile.save
      redirect_to current_user.default_landing_page
    else
      get_preference_completeness
      slider_order_completeness
      get_categories_and_deserve_it(@user_profile)
    end
  end
    
  def sg_categories
    @user_profile = current_user.user_profile.present? ? (current_user.user_profile) : (current_user.build_user_profile)
    get_categories_and_deserve_it(@user_profile)
    category_classify
  end

  def category_save
    @user_profile = current_user.user_profile.presence || current_user.build_user_profile
    @user_profile.category_flag = 1
    @user_profile.adv_pref_flag = 1
    @user_profile.customize_avatars = 1
    #user_profile.get_default_landing_page
    @user_profile.offer_category_1 = params[:user_profile][:offer_category_1]
    @user_profile.offer_category_2 = params[:user_profile][:offer_category_2]
    @user_profile.offer_category_3 = params[:user_profile][:offer_category_3]
    @user_profile.suggestion_category_1 = params[:user_profile][:suggestion_category_1]
    @user_profile.suggestion_category_2 = params[:user_profile][:suggestion_category_2]
    @user_profile.suggestion_category_3 = params[:user_profile][:suggestion_category_3]
    @user_profile.you_deserve_it_category = params[:user_profile][:you_deserve_it_category]
    @user_profile.populate_locale
    if @user_profile.save
      activity = current_user.activities.build
      activity.sub_type = "preference"
      activity.icon_path = @user_profile.icon_path
      activity.update_my_activity(@user_profile, "Updated", "Insider Preferences", UserProfile::Kudos_Points::Insider_preferences)
    end
    get_categories_and_deserve_it(@user_profile)
  end

  def reset
    @user_profile = current_user.user_profile.present? ? (current_user.user_profile) : (current_user.build_user_profile)
    @photo = @user_profile.photo.present? ? (@user_profile.photo) : (@user_profile.build_photo)
    get_preference_completeness
    slider_order_completeness
    get_categories_and_deserve_it(@user_profile)
  end

  def customize_avatar
    @user_profile = current_user.user_profile.present? ? (current_user.user_profile) : (current_user.build_user_profile)
    @photo = @user_profile.photo.present? ? (@user_profile.photo) : (@user_profile.build_photo)
    @user_profile.insider_icon_img = "insider_#{params[:insider][:gender]}_#{params[:insider][:hair]}_#{params[:insider][:skin]}"
    @user_profile.sidekick_icon_img = "sidekick_#{params[:sidekick][:gender]}_#{params[:sidekick][:hair]}_#{params[:sidekick][:skin]}"
    @user_profile.assistant_icon_img = "assistant_#{params[:assistant][:gender]}_#{params[:assistant][:hair]}_#{params[:assistant][:skin]}"

    @user_profile.category_flag = 1
    @user_profile.adv_pref_flag = 1
    @user_profile.customize_avatars = 1
    if @user_profile.save(:validate => false)
      activity = current_user.activities.build
      activity.icon_path = @user_profile.photo.present? ? (@user_profile.photo.image_url(:standard_image)):(@user_profile.build_photo.image_url(:standard_image))
      activity.update_my_activity(@user_profile, "Configured", "Advisors", UserProfile::Kudos_Points::Avatar)
    end
  end

  def update_questions
    @user_profile = current_user.user_profile.present? ? (current_user.user_profile) : (current_user.build_user_profile)
    @user_profile.populate_questions(params[:slider_1], params[:slider_2], params[:slider_3], params[:offer_order_1], params[:offer_order_2], params[:offer_order_3])
    @user_profile.repeat_experiences = params[:user_profile][:repeat_experiences].present? ? (1) : (0)
    @user_profile.question_3 = params[:user_profile][:question_3]
    @user_profile.question_4 = params[:user_profile][:question_4]
    @user_profile.question_5 = params[:user_profile][:question_5]
    @user_profile.populate_locale
    @user_profile.category_flag = 1
    @user_profile.adv_pref_flag = 1
    @user_profile.customize_avatars = 1
    if @user_profile.save
      activity = current_user.activities.build
      activity.sub_type = "question"
      activity.icon_path = @user_profile.photo.present? ? (@user_profile.photo.image_url(:standard_image)):(@user_profile.build_photo.image_url(:standard_image))
      activity.update_my_activity(@user_profile, "Configured", "Six Questions", UserProfile::Kudos_Points::Six_Questions)
    end
    get_preference_completeness
    slider_order_completeness
    #get_categories_and_deserve_it(@user_profile)
  end


  def adv_preference
    @user_profile = current_user.user_profile.present? ? (current_user.user_profile) : (current_user.build_user_profile)
    get_preference_completeness
    slider_order_completeness
    get_categories_and_deserve_it(@user_profile)
  end

  private

  def category_classify
    #    up_cat = [@user_profile.offer_category_first, @user_profile.offer_category_second,
    #      @user_profile.offer_category_third, @user_profile.suggestion_category_first,
    #      @user_profile.suggestion_category_first, @user_profile.suggestion_category_first,
    #      @user_profile.you_deserve_it_category ]
    
    @business_categories = Category.preference_category("business")
    @food_categories = Category.preference_category("food")
    @lifestyle_categories = Category.preference_category("lifestyle")
    @travel_categories = Category.preference_category("travel")
    @shopping_categories = Category.preference_category("shopping")
  end

  def get_categories_and_deserve_it(user_profile)
    top_3_categories(user_profile)
    top_3_suggestions(user_profile)
    you_deserve_it(user_profile)
  end

  
  def top_3_categories(user_profile)
    @offer_category_1 = user_profile.offer_category_first
    @offer_category_2 = user_profile.offer_category_second
    @offer_category_3 = user_profile.offer_category_third
  end

  def top_3_suggestions(user_profile)
    @suggestion_category_1 = user_profile.suggestion_category_first
    @suggestion_category_2 = user_profile.suggestion_category_second
    @suggestion_category_3 = user_profile.suggestion_category_third
  end

  def you_deserve_it(user_profile)
    @you_deserve_it = user_profile.deserve_it
  end
  
  def get_preference_completeness
    @perf_completeness = UserProfile.pref_completeness(current_user)
    logger.debug "*********"
    logger.debug @perf_completeness
    logger.debug "*********"
  end

  def slider_order_completeness
    @slider_values = @user_profile.question_1.split(',') if @user_profile.question_1.present?
    @order_values = @user_profile.question_2.split(',') if @user_profile.question_2.present?
  end

  def get_not_connected_social_medias
    @remaining_social_medias = SocialMedia.all - current_user.social_medias
  end
  
end
