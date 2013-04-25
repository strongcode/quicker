module KudosPoints
  def update_kudos_points
    self.kudos_points = self.kudos_score
  end

  def create_activity
    activity = self.reflections.keys.include?(:activities) ? (self.activities.build) : (self.build_activity)
    activity.date = self.created_at
    activity.description = self.description
    activity.icon_path = self.icon_path(self.user.user_profile)
    activity.action = self.action
    activity.user_id = self.user.id
    activity.kudos_points = self.set_kudos_score
    if activity.save && self.user.present?
      self.user.kudos_points = (self.user.kudos_points.present? ? (self.user.kudos_points) : (0)) + activity.kudos_points
      self.user.save
    end
  end

  def create_user_activity
    activity = self.reflections.keys.include?(:activities) ? (self.activities.build) : (self.build_activity)
    activity.date = self.created_at
    activity.description = self.description
    activity.icon_path = self.icon_path(self.user_profile)
    activity.action = self.action
    activity.kudos_points = self.set_kudos_score
    if activity.save 
      self.kudos_points = (self.kudos_points.present? ? (self.kudos_points) : (0)) + activity.kudos_points
      save
    end
  end

  def create_goal_completed_activity
    if self.completed?
      activity = self.activities.build
      activity.date = self.ended_date
      activity.description = self.description
      activity.icon_path = self.icon_path(self.user.user_profile)
      activity.action = self.action
      activity.user_id = self.user_id
      activity.kudos_points = self.set_kudos_goal_completed_score
      if activity.save && self.user.present?
        self.user.kudos_points = (self.user.kudos_points.present? ? (self.user.kudos_points) : (0)) + activity.kudos_points
        self.user.save
      end
      
    end
  end

  def create_fr_activity
    to_user = User.find self.friend_from_id
    activity = self.build_activity
    activity.date = self.created_at
    activity.description = self.description
    activity.icon_path = self.icon_path(self.user.user_profile)
    activity.action = self.action
    activity.user_id = to_user.id
    activity.kudos_points = self.set_kudos_score
    if activity.save && to_user.present?
      to_user.kudos_points = (to_user.kudos_points.present? ? (to_user.kudos_points) : (0)) + activity.kudos_points
      to_user.save
    end
  end

  def create_goal_photo_activity
    if self.imageable_type == 'Goal'
      activity = self.build_activity
      activity.date = self.created_at
      activity.description = self.goal_photo_description
      activity.icon_path = self.goal_photo_icon_path
      activity.action = self.goal_action
      activity.user_id = self.get_user_id
      activity.kudos_points = self.set_kudos_score
      if activity.save && activity.user.present?
        activity.user.kudos_points = (activity.user.kudos_points.present? ? (activity.user.kudos_points) : (0)) + activity.kudos_points
        activity.user.save
      end
    end
  end

  def create_share_activity
    user = self.shareable.user.present? ? (self.shareable.user) : (self.get_shared_user)
    activity = self.build_activity
    activity.date = self.created_at
    activity.description = self.shareable.share_description
    activity.icon_path = self.shareable.icon_path(user.user_profile)
    activity.action = self.shareable.share_action
    activity.user_id = self.user_id
    activity.kudos_points = self.shareable.set_share_score
    if activity.save && activity.user.present?
      activity.user.kudos_points = (activity.user.kudos_points.present? ? (activity.user.kudos_points) : (0)) + activity.kudos_points
      activity.user.save
    end
  end

  
end