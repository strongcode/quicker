module DashboardHelper
  def activity_for_mustache(activity)
    {:icon_path => activity.custom_icon_path,
      :date => l(activity.updated_at.to_date),
      :action => activity.action,
      :description => activity.description,
      :kudos_points => activity.kudos_points.to_i
    }
  end

  def custom_friend_submit_tag
    if current_user.friends.present?
      submit_tag 'Delete', :class =>"btn btn-info bd-delete-btn sg-archive jQueryDeleteFr", :data => {:confirm => 'Are you sure'}
    else
      submit_tag 'Delete', :class =>"btn btn-info bd-delete-btn sg-archive jQueryDeleteFr", :data => {:confirm => 'Are you sure'}, :disabled => true
    end
  end

  def custom_friend_request_submit_tag
    if current_user.friend_requests.present?
      submit_tag t('dashboard.decline'), :class => 'btn btn-info savebtn sg-archive jQueryArchive', :data => {:confirm => 'Are you sure?'}
    else
      submit_tag t('dashboard.decline'), :class => 'btn btn-info savebtn sg-archive jQueryArchive', :data => {:confirm => 'Are you sure?'}, :disabled => true
    end
  end

  def membership_link type
    new_type = type.split(/(\W)/).map(&:capitalize).join
    type == 'co-founder' ? (link_to new_type, '#membership_popup', :class => 'fancybox' ) : (new_type)
  end

end
