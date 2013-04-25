module Sidekick::LocationsHelper
  def get_reviewer_image(reviewer_of_the_day)
    if reviewer_of_the_day.present? && reviewer_of_the_day.user_profile.present?
      if reviewer_of_the_day.user_profile.photo.present? && reviewer_of_the_day.user_profile.photo.image.present?
        link_to (image_tag reviewer_of_the_day.user_profile.photo.image_url(:small_image), :alt => '', :style => 'height:45px; width:45px;'), reviewer_user_path(reviewer_of_the_day)
      elsif reviewer_of_the_day.user_profile.picture.present?
        link_to (image_tag reviewer_of_the_day.user_profile.picture, :style => 'height:45px; width:45px;'), reviewer_user_path(reviewer_of_the_day)
      else
        image_tag 'profile-images/blank-profile.png', :style => 'height:45px; width:45px;'
      end
    else
      if current_user.present? && current_user.user_profile.present? && current_user.user_profile.photo.present? && current_user.user_profile.photo.image.present?
        image_tag current_user.user_profile.photo.image_url(:small_image), :alt => '', :style => 'height:45px; width:45px;'
      elsif current_user.user_profile.picture.present?
        image_tag reviewer_of_the_day.user_profile.picture, :style => 'height:45px; width:45px;'
      else
        image_tag 'profile-images/blank-profile.png', :style => 'height:45px; width:45px;'

      end
    end
    
  end

  def get_reviewer_name(reviewer_of_the_day)
    if reviewer_of_the_day.present?
      if reviewer_of_the_day.id == current_user.id
        reviewer_of_the_day.reviews.with_comment.count > 0 ? (link_to "It's You", reviewer_user_path(reviewer_of_the_day)) : ("This Could Be You")
      else
        reviewer_of_the_day.reviews.with_comment.count > 0 ? (link_to reviewer_of_the_day.full_name, reviewer_user_path(reviewer_of_the_day)) : ("This Could Be You")
      end
    else
      "This Could Be You"
    end
  end

  def get_reviews_count(reviewer_of_the_day)
    if reviewer_of_the_day.present? && reviewer_of_the_day.reviews.with_comment.count > 0
      content_tag :div, :class => 'number_reviews', :style => '' do
        pluralize(reviewer_of_the_day.reviews.with_comment.count, t('sidekick.review'))
      end
    else
      ''
    end
  end

  def location_link(suggestion_locations, location, location_list)
    if location.is_passionate_and_suggestion_location?(suggestion_locations, current_user)
      link_path = details_sidekick_location_review_url(location, :location_list_id => location_list.id)
    elsif location.is_suggestion_location?(suggestion_locations)
      link_path = edit_insider_suggestion_path(location.suggestions.first)
    else
      link_path = details_sidekick_location_review_url(location, :location_list_id => location_list.id)
    end
    link_to("#{location.name.presence || location.full_address}" , link_path , :class => 'fancybox_iframe fancybox.iframe')
  end

  def user_default_location(location, passionate_location)
    if location.present?
      location.full_address
    else
      current_user.user_profile.location_name
    end
  end

  def list_share_cancel_link
    if request.referer.match(/sidekick/i)
      link_to "cancel", '#', :class => 'btn btn-info cancelbtn jQueryFancyboxIframeClose'
    else
      link_to "cancel", list_location_lists_url, :class => 'btn btn-info cancelbtn'
    end

  end
  
end