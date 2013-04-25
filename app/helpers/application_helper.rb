module ApplicationHelper

  def offer_image_path(offer)
    if offer.present?
      if offer.large_image_url.present?
        offer.large_image_url
      elsif offer.small_image_url.present?
        offer.small_image_url
      else
        "/assets/no-image.png"
      end
    else
      "/assets/no-image.png"
    end
  end

  def formatted_offer_title(offer)
    if offer.present?
      merchant_name = offer.merchant_name
      if offer.offer_redemption_locations.present?
        redemption_neighborhood = offer.offer_redemption_locations.first.redemption_neighborhood
        if merchant_name.present? && redemption_neighborhood.present?
          "#{merchant_name} - #{redemption_neighborhood}"
        elsif merchant_name.present? && redemption_neighborhood.blank?
          merchant_name
        elsif merchant_name.blank? && redemption_neighborhood.present?
          redemption_neighborhood
        else
          t(:couldnt_find_anything!)
        end
      elsif offer.redemption_location.present?
        "#{merchant_name} - #{offer.redemption_location}"
      else
        "#{merchant_name}"
      end
    else
      t(:couldnt_find_anything!)
    end
  end

  def get_button(text = 'Login')
    content_tag :button, :type => :button, :id => 'login', :class => 'btn btn-info' do
      text
    end
  end

  def reg_button
    content_tag :button, :type => :button, :class => 'btn1 btn-primary1 btn1_width', :style => 'font-weight: bold' do
      image_tag('snap_icon.png', :alt => 'snap_icon_image') + " " + " "+ "Snap to It"
    end
  end

  def cancel_button
    content_tag :button, :type => :button
    image_tag('cancel.png', :alt => 'cancel_image')
  end

  def save_button
    content_tag :button, :type => :button
    image_tag('save.png', :alt => 'save_image')
  end

  def get_image(user_profile)
    if user_profile.present?
      if user_profile.photo.present? && user_profile.photo.image.present?
        image_tag user_profile.photo.image_url(:standard_image), :style => 'height:90px;width:90px;', :alt => '', :id => 'jQuery-Profile-Img', "data-id" => user_profile.user_id
      elsif user_profile.picture.present?
        image_tag user_profile.picture, :style => 'height:90px;width:90px;', :id => 'jQuery-Profile-Img', "data-id" => user_profile.user_id
      else
        image_tag 'profile-images/blank-profile.png', :style => 'height:90px;width:90px;', :id => 'jQuery-Profile-Img', "data-id" => user_profile.user_id
      end
    end
  end
  
  def get_friends_image(user_profile, fr_request = '')
    if user_profile.present?
      if user_profile.photo.present?
        image_tag user_profile.photo.image_url(:standard_image), :style => 'height:90px;width:90px;', :alt => '', :title => "#{fr_request.present? ? (fr_request.friend_from_message) : ('')}"
      elsif user_profile.picture.present?
        image_tag user_profile.picture, :style => 'height:90px;width:90px;', :title => "#{fr_request.present? ? (fr_request.friend_from_message) : ('')}"
      else
        image_tag 'profile-images/blank-profile.png', :style => 'height:90px;width:90px;', :title => "#{fr_request.present? ? (fr_request.friend_from_message) : ('')}"
      end
    else
      image_tag 'profile-images/blank-profile.png', :style => 'height:90px;width:90px;', :title => "#{fr_request.present? ? (fr_request.friend_from_message) : ('')}"
    end
  end
  
  def get_profile_image(user_profile, path = nil)
    if user_profile.present?
      if user_profile.photo.present? && user_profile.photo.image.present?
        path.blank? ? (image_tag user_profile.photo.image_url(:standard_image), :alt => '') : (user_profile.photo.image_url(:standard_image))
      elsif user_profile.picture.present?
        path.blank? ? (image_tag user_profile.picture, :style => 'height:90px;width:90px;') : (user_profile.picture)
      else
        path.blank? ? (image_tag 'profile-images/blank-profile.png') : ('assets/profile-images/blank-profile.png')
      end
    else
      path.blank? ? (image_tag 'profile-images/blank-profile.png') : ('assets/profile-images/blank-profile.png')
    end

  end
  def get_page_id(page)
    (SgPage.find_by_name page).try(&:id)
  end

  def get_http_method
    controller.action_name == 'update' ? ('PUT') : ('POST')
  end

  def user_full_name(user)
    user.present? ? (user.full_name ) :("")
  end

  def check_for_question_image(user_preference, option)
    if user_preference.question_2.present?
      options = user_preference.question_2.split(',')
      options.include?(option) ? () : (image_tag "#{option}_disable.png", :id => option, :ondragstart => "drag_calender(event)", :draggable => "true")
    else
      image_tag "#{option}_disable.png", :id => option, :ondragstart => "drag_calender(event)", :draggable => "true"
    end

  end

  def get_language_locale(lang)

    case lang.description
    when "English"
      t(:english)
    when "Spanish"
      t(:spanish)
    end

  end

  def get_category_title(category)
    case category
    when "food"
      t(:food_and_beverage)
    when "business"
      t(:business_and_services)
    else
      t(category.to_sym).capitalize
    end
  end

  def get_category(category)
    case category
    when "lifestyle"
      t(:lifestyle)
    when "business"
      t(:business_and_services)
    when "food"
      t(:food_and_beverage)
    when "shopping"
      t(:shopping)
    when "travel"
      t(:travel)
    when "friend"
      t(:friends)
    else

    end
  end


  def review_created_on(review)
    review.new_record? ? () : ("Created #{review.created_at.strftime('%m/%d/%Y')}")
  end

  def review_updated_on(review)
    review.new_record? ? () : ("Updated #{review.updated_at.strftime('%m/%d/%Y')}")
  end

  def last_review(review)
    review.present? ? () : ("Last Review #{review.created_at.strftime('%m/%d/%Y')}")
  end

  def get_location_name(location_id)
    loc = Location.find_by_id location_id
    loc.present? ? (loc.name) : ("")
  end

  def get_categories
    if current_user.user_profile.present?
      categories = MajorCategory.all.sort_by { |category| category.display_order }
      english_map = categories.map { |category| [category.english_version.titlecase, category.major_category_name] }
      case current_user.user_profile.locale
      when "en"
        english_map
      when "es"
        categories.map { |category| [category.spanish_version.titlecase, category.major_category_name] }
      end
    else
      english_map
    end
  end
  
  def get_category_description(desc)
    desc = desc.gsub('/', '_').gsub(/[\(\)\-\&\']/, '')
    desc = desc.split.join(' ').downcase
    desc = desc.gsub(' ', '_').gsub("'", '')
    t("category.#{desc}")
  end

  def get_title(name)
    case name
    when "Fitness"
      t(:fitness)
    when "Charity"
      t(:charity)
    when "Financial"
      t(:financial)
    when "Education"
      t(:educational)
    when "Social"
      t(:social)
    when "Spiritual"
      t(:spirituality)
    when "Career"
      t(:career)
    when "Personal"
      t(:personal)
    else

    end
  end

  def membership_list(membership_type)
    case membership_type
    when "Founder"
      t(:founder)
    when "Premium"
      t(:premium)
    when "Standard"
      t(:standard)
    else

    end
  end

  def logo_image
    image_tag 'logo/snapgadget_logo_live.png', :alt => 'Logo Image', :class => 'img'
  end

  def my_color_is?(_object)
    what = _object.is
    case what
    when SG::SIDEKICK
      'b85957'
    when SG::ASSISTANT
      '682036'
    when SG::INSIDER
      'f5c36c'
    else
      '#ffffff'
    end
  end

  def my_friends_location_lists(count)
    span = content_tag :span, :class => 'sk_list_text' do
      "#{t('location_list.view_my_friends_location_lists')} - #{@friends_location_lists.count}"
    end
    count > 0 ? (link_to "#{t('location_list.view_my_friends_location_lists')} - #{@friends_location_lists.count}", friends_location_lists_url, :class => 'fancybox_iframe fancybox_iframe.iframe sk_list_text') : (span)
  end

  def custom_error_message(resource, field)
    if resource.present? && resource.errors.messages[field].present?
      content_tag :p, "#{field.to_s.gsub('_',' ').capitalize} #{resource.errors.messages[field][0]}",
        :class => 'server_side_error'
    else
      ''
    end
  end

  def custom_error_message_no_margin_no_field_name(resource, field, margin = 0)
    if resource.present? && resource.errors.messages[field].present?
      content_tag :p, "#{resource.errors.messages[field][0]}", :class => 'server_side_error_1', :style => "margin-left:#{margin}px;"
    else
      ''
    end
  end

  def custom_error_message_no_margin(resource, field)
    if resource.present? && resource.errors.messages[field].present?
      content_tag :p, "#{field.to_s.gsub('_',' ').capitalize} #{resource.errors.messages[field][0]}",
        :class => 'server_side_error_1'
    else
      ''
    end
  end
  
  def custom_error_message_modified(resource, field)
    if resource.present? && resource.errors.messages[field].present?
      "#{field.to_s.gsub('_',' ').capitalize} #{resource.errors.messages[field][0]}"
    else
      ''
    end
  end

  def custom_error_message_goals(resource, field, html_tag)
    if resource.present? && resource.errors.messages[field].present?
      content_tag html_tag, "#{field.to_s.gsub('_',' ').capitalize} #{resource.errors.messages[field][0]}", :class => 'server_side_error', :style => 'margin-left:34.9%;'
    else
      ''
    end

  end

  def get_share_label
    session[:trail] == 'sidekick' ? (t 'share.location_list.share_your_location_of') : (t 'share.location_list.share_your_suggestion_of')
  end

  def get_advisor_icon(advisor)
    if current_user.user_profile.present? && current_user.user_profile.send("#{advisor}_icon_img").present?
      image_tag "/assets/advisor_icons/#{advisor}/#{current_user.user_profile.send("#{advisor}_icon_img")}.png"
    else
      image_tag "/assets/advisor_icons/#{advisor}/#{advisor}_male_d6c4c2_ffd8b6.png"
    end
  end

  def insider_preferences_link
    link_to 'Preferences', sg_category_url, :class => 'black-on-gray fancybox_large', 'data-fancybox-type' => "ajax"
  end

  def custom_share_link(object, link, klass = '')
    @friends = Tracker.non_shared_friends(object, current_user)
    if @friends.count > 0
      link_to image_tag('share_btn/share_btn_big.png'), link, :class => klass
    else
      if current_user.friends.blank?
        image_tag 'share_btn/share_btn_disable.png', :title => 'To Share, Add Friends'
      else
        image_tag 'share_btn/share_btn_disable.png', :title => 'Already shared with all Friends'
      end
    end
  end

  def get_profile_image_full_path
    configatron.site_address_full + get_profile_image(current_user.user_profile, true)
  end

end















