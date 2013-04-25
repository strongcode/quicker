module UserProfilesHelper

  def profile_path
    @profile_user.user_profile.present? ? (edit_user_profile_url) : (new_user_profile_url)
  end

  def preference_path
    @profile_user.user_profile.present? ? (edit_user_profile_url) : (new_user_profile_url)
  end

  def preference_image(category, index)
    category.present? ? (image_tag "/assets/CategoryImages/#{category.photo}", :alt => '', :title => category.description, :ondragstart => "category_drag(event)", :draggable => "true", :class => "img", "data-category-id" => category.id) : (image_tag "placeholders/d#{index}.png", :alt => '',:class => 'img')
  end

  def change_or_add_offers
    (@profile_user.user_profile.present? &&
        (@profile_user.user_profile.offer_category_1 || @profile_user.user_profile.offer_category_2 || @profile_user.user_profile.offer_category_3)) ? (t(:change)) : (t(:add))
  end

  def change_or_add_suggestions
    (@profile_user.user_profile.present? && (@profile_user.user_profile.offer_category_1 || @profile_user.user_profile.offer_category_2 || @profile_user.user_profile.offer_category_3)) ? (t(:change)) : (t(:add))
  end

  def change_or_add_deserve_it
    (@profile_user.user_profile.present? && (@profile_user.user_profile.offer_category_1 || @profile_user.user_profile.offer_category_2 || @profile_user.user_profile.offer_category_3)) ? (t(:change)) : (t(:add))
  end

  def progress_bar(width)
    content_tag(:div, "", :class => 'bar', :style => "width:#{width}%")
  end

  def perference_image_adv(category, index)
    category.present? ? (image_tag "/assets/CategoryImages/#{category.photo}", :alt => '', :title => category.description, :class => 'border-and-radius', :style => "max-width: 85px;max-height: 85px;") : (image_tag "/assets/place_holder_#{index}.png", :alt => '', :style => "max-width: 85px;max-height: 85px;")
  end

  def get_rank_options(order_value, index)
    order_value.present? ? (image_tag "/assets/#{order_value[index]}_disable.png", :id => order_value[index], :ondragstart => "drag_calender(event)", :draggable => "true", 'data-allow-drop' => 'true') : ('')
  end

  def slider_values(slider_values, index)
    slider_values.present? ? ("#{slider_values[index - 1]}%") : ("0%")
  end

  def get_passionate_link(passionate)
    if passionate.present?
      link_to t(:change), edit_sidekick_passionate_url, :class => 'btn btn-info prefer_revist_btn fancybox_iframe_large fancybox.iframe'
    else
      link_to t(:add), new_sidekick_passionate_url, :class => 'btn btn-info prefer_revist_btn fancybox_iframe_large fancybox.iframe'
    end
  end

  def male?(advisor_icon)
    if advisor_icon.present?
      advisor_icon.split('_')[1] == 'male'
    else
      true
    end
  end
  
  def female?(advisor_icon)
    if advisor_icon.present?
      advisor_icon.split('_')[1] == 'female'
    else
      false
    end
  end

  def adv_image(advisor)
    if current_user.user_profile.present? && current_user.user_profile.send("#{advisor}_icon_img").present?
      image_path = current_user.user_profile.send("#{advisor}_icon_img")
      image_tag "advisor_icons/#{advisor}/#{image_path}.png", :class => 'advisor_image'
    else
      image_path = "#{advisor}_male_d6c4c2_ffd8b6.png"
      image_tag "advisor_icons/#{advisor}/#{image_path}.png", :class => 'advisor_image'
    end

  end
  
end
