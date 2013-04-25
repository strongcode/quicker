class Activity < ActiveRecord::Base
  attr_accessible :activitable_type, :activitable_id, :date, :action, :description,  :kudos_points, :sub_type

  belongs_to :activitable, :polymorphic => true
  belongs_to :user

  #before_save :check_for_limit

  acts_as_paranoid

  Max_Activities_Per_Day = 1
  
  module Kudos_Scores
    Goal_Completed = 100
  end
  scope :custom_activities, proc {|type| where("activitable_type = ?", type)}
  scope :page_wise, proc {|month_number| where("(updated_at >= '#{month_number.months.ago.to_date.beginning_of_day}' AND updated_at <= '#{(month_number - 1).months.ago.to_date.end_of_day + 1.day}') OR (created_at >= '#{month_number.months.ago.to_date.beginning_of_day}' AND created_at <= '#{(month_number - 1).months.ago.to_date.end_of_day + 1.day}')", month_number)}
  scope :created_today, proc{|activity| where("sub_type = ? AND DATE(created_at) = DATE(?)", activity.sub_type, Time.now)}
  scope :non_zero_kudos, where('kudos_points > 0')

  def set_sub_type
    @sub_type = nil
  end

  def check_for_limit
    current_user = self.user
    user_profile = current_user.user_profile
    if user_profile.present? && user_profile.activities.created_today(self).count >= Max_Activities_Per_Day
      return false
    end
  end

  def custom_icon_path
    activitable_type == 'Photo' ? (activitable.image_url(:standard_image)) : (icon_path)
  end

  def update_my_activity(activitable, action = nil, description = nil, kp = -1)
    self.activitable = activitable
    self.description = description.present? ? (description) : (activitable.description)
    self.action = action.present? ? (action) : (activitable.action)
    self.kudos_points = kp != -1 ? (kp) : (activitable.set_kudos_score)
    self.date = activitable.updated_at
    if self.save && self.user.present?
      self.user.kudos_points = (self.user.kudos_points.present? ? (self.user.kudos_points) : (0)) + self.kudos_points
      self.user.save
    end
  end

  def update_user_profile_activity

  end
  
end
