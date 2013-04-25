class UserPreferencesController < ApplicationController

  before_filter :authenticate_user!
  skip_before_filter :check_for_user_preference, :only => [:new, :create, :sg_categories, :sg_suggestions, :sg_deserve_it, :category_save, :u_deserve_it_save]

  def new
    if @profile_user.user_preference.present?
      redirect_to edit_user_preference_url
      return
    end
    @user_preference = @profile_user.build_user_preference
    @user_preference.get_default_landing_page
    get_categories_and_deserve_it(@user_preference)
    slider_order_completeness
    get_preference_completeness
  end

  def create
    @user_preference = @profile_user.build_user_preference(params[:user_preference])
    @user_preference.populate_questions(params[:slider_1], params[:slider_2], params[:slider_3], params[:offer_order_1], params[:offer_order_2], params[:offer_order_3])
    if @user_preference.save
      redirect_to params[:adv_pref_save].present? ? (new_user_preference_url) : (current_user.default_landing_page)
    else
      get_preference_completeness
      slider_order_completeness
      get_categories_and_deserve_it(@user_preference)
      render 'new'
    end

  end

  def edit
    unless @profile_user.user_preference.present?
      redirect_to new_user_preference_url
      return
    end
    @user_preference = @profile_user.user_preference
    slider_order_completeness
    get_preference_completeness
    get_categories_and_deserve_it(@user_preference)
  end

  def update
    @user_preference = @profile_user.user_preference
    @user_preference.populate_questions(params[:slider_1], params[:slider_2], params[:slider_3], params[:offer_order_1], params[:offer_order_2], params[:offer_order_3])
    if @user_preference.update_attributes(params[:user_preference])
      @user_preference.save
      redirect_to params[:adv_pref_save].present? ? (new_user_preference_url) : (@profile_user.default_landing_page)
    else
      get_preference_completeness
      slider_order_completeness
      get_categories_and_deserve_it(@user_preference)
      render 'edit'
    end
  end

  def sg_categories
    @user_preference = @profile_user.user_preference.present? ? (@profile_user.user_preference) : (@user_preference = @profile_user.build_user_preference)
    top_3_categories(@user_preference)
    category_classify
  end

  def sg_suggestions
    @user_preference = @profile_user.user_preference.present? ? (@profile_user.user_preference) : (@user_preference = @profile_user.build_user_preference)
    top_3_suggestions(@user_preference)
    category_classify
  end
  
  def sg_deserve_it
    @user_preference = @profile_user.user_preference.present? ? (@profile_user.user_preference) : (@user_preference = @profile_user.build_user_preference)
    you_deserve_it(@user_preference)
    category_classify
  end

  def category_save
    user_preference = @profile_user.user_preference.presence || @profile_user.build_user_preference
    user_preference.get_default_landing_page
    user_preference.update_attributes(params[:user_preference])
    redirect_to request.referer
  end

  def suggestion_save
    user_preference = @profile_user.user_preference.presence || @profile_user.build_user_preference
    user_preference.get_default_landing_page
    user_preference.update_attributes(params[:user_preference])
    redirect_to request.referer
  end

  def u_deserve_it_save
    user_preference = @profile_user.user_preference.presence || @profile_user.build_user_preference
    user_preference.get_default_landing_page
    user_preference.update_attributes(params[:user_preference])
    redirect_to request.referer
  end


  private

  def category_classify
    #    up_cat = [@user_preference.offer_category_first, @user_preference.offer_category_second,
    #      @user_preference.offer_category_third, @user_preference.suggestion_category_first,
    #      @user_preference.suggestion_category_first, @user_preference.suggestion_category_first,
    #      @user_preference.you_deserve_it_category ]
    
    @business_categories = Category.preference_category("business")
    @food_categories = Category.preference_category("food")
    @lifestyle_categories = Category.preference_category("lifestyle")
    @travel_categories = Category.preference_category("travel")
    @shopping_categories = Category.preference_category("shopping")
  end

  def get_categories_and_deserve_it(user_preference)
    top_3_categories(user_preference)
    top_3_suggestions(user_preference)
    you_deserve_it(user_preference)
  end

  
  def top_3_categories(user_preference)
    @offer_category_1 = user_preference.offer_category_first
    @offer_category_2 = user_preference.offer_category_second
    @offer_category_3 = user_preference.offer_category_third
  end

  def top_3_suggestions(user_preference)
    @suggestion_category_1 = user_preference.suggestion_category_first
    @suggestion_category_2 = user_preference.suggestion_category_second
    @suggestion_category_3 = user_preference.suggestion_category_third
  end

  def you_deserve_it(user_preference)
    @you_deserve_it = user_preference.deserve_it
  end
  
  def get_preference_completeness
    @perf_completeness = UserPreference.pref_completeness(@profile_user)
  end

  def slider_order_completeness
    @slider_values = @user_preference.question_1.split(',') if @user_preference.question_1.present?
    @order_values = @user_preference.question_2.split(',') if @user_preference.question_2.present?
  end

  
end
