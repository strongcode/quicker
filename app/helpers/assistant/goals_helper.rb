module Assistant::GoalsHelper
  def get_traker_image(user_profile, share)
    if user_profile.present?
      if user_profile.photo.present?
        image_tag user_profile.photo.image_url(:standard_image), :style => 'height:85px;width:85px;', :alt => '', :title => share.comment
      elsif user_profile.picture.present?
        image_tag user_profile.picture, :style => 'height:85px;width:85px;', :title => share.comment
      end
    else
      image_tag 'default_man2.png', :style => 'max-height:85px;width:85px;', :title => share.comment
    end
  end
  
end