class Goal < ActiveRecord::Base
  include ActionView::Helpers::DateHelper
  include KudosPoints
  
  attr_accessible :completed, :description, :end_date, :ended_date, :feeds,
    :goal_type, :started_date, :status_percentage, :user_id, :photos_attributes, :notes

  #default_scope order('started_date desc')

  acts_as_paranoid
  attr_accessor :kudos_score

  module Kudos_Pts
    Create_Goal = 2
    Share_Goal = 2
    Upload_Goal_Picture = 1
    Complete_Goal = 3
  end

  module Messages
    Not_Started = "Goal Not Started"
  end

  COMPLETED = 1
  NOT_COMPLETED = 0

  module GoalType
    FITNESS = {:name => 'Fitness',:title => 'Fitness',
      :disabled_image_path => 'goal_types/fitness_btn_d.gif',
      :enabled_image_path => 'goal_types/fitness_btn.gif'}
    CHARITY = {:name => 'Charity',
      :disabled_image_path => 'goal_types/charity_btn_d.gif',
      :enabled_image_path => 'goal_types/charity_btn.gif'}
    FINANCIAL = {:name => 'Financial',
      :disabled_image_path => 'goal_types/financial_btn_d.gif',
      :enabled_image_path => 'goal_types/financial_btn.gif'}
    EDUCATION = {:name => 'Education',
      :disabled_image_path => 'goal_types/education_btn_d.gif',
      :enabled_image_path => 'goal_types/education_btn.gif'}
    SOCIAL = {:name => 'Social',
      :disabled_image_path => 'goal_types/social_btn_d.gif',
      :enabled_image_path => 'goal_types/social_btn.gif'}
    SPIRITUAL = {:name => 'Spiritual',
      :disabled_image_path => 'goal_types/spritual_btn_d.gif',
      :enabled_image_path => 'goal_types/spritual_btn.gif'}
    CAREER = {:name => 'Career',
      :disabled_image_path => 'goal_types/career_btn_d.gif',
      :enabled_image_path => 'goal_types/career_btn.gif'}
    PERSONAL = {:name => 'Personal',
      :disabled_image_path => 'goal_types/personal_btn_d.gif',
      :enabled_image_path => 'goal_types/personal_btn.gif'}
  end

  validates :description, :end_date, :goal_type, :started_date, :user_id, :completed, :presence => true
  validates :status_percentage, :completed, :numericality => true

  validates_datetime :started_date, :allow_blank => true
  validates_datetime :end_date, :after => :started_date, :allow_blank => true
  validates_datetime :ended_date, :after => :started_date, :allow_blank => true
  validates_datetime :deleted_at, :allow_blank => true

  validates :goal_type, :inclusion => {:in => GoalType.constants.map { |const| GoalType.const_get(const)[:name] }, :allow_blank => true}
  validates :completed, :inclusion => {:in => [COMPLETED, NOT_COMPLETED]}

  belongs_to :user

  has_many :trackers, :as => :trackable, :dependent => :destroy
  has_many :photos, :as => :imageable, :dependent => :destroy
  has_many :shares, :as => :shareable, :dependent => :destroy
  has_many :activities, :as => :activitable

  after_initialize :set_kudos_score
  before_validation :alter_attributes
  after_create :create_activity
  after_update :create_goal_completed_activity

  def set_kudos_score
    @kudos_score = Goal::Kudos_Pts::Create_Goal
  end

  scope :not_completed, where("status_percentage != 100").order('created_at DESC')
  scope :finished, proc {|user| where('status_percentage = 100 AND user_id = ?', user.id ).order('ended_date DESC') }
  scope :completed, where("status_percentage = 100")

  accepts_nested_attributes_for :photos, :allow_destroy => true

  def goal_type_hash
    Goal::GoalType.constants.map { |const| Goal::GoalType.const_get(const) }.find { |_goal_type| _goal_type[:name] == goal_type }
  end

  def alter_attributes
    self.started_date = started_date.beginning_of_day if started_date?
    self.end_date = end_date.end_of_day if end_date?
    self.ended_date = ended_date.end_of_day if ended_date?
  end

  def completed?
    completed == COMPLETED
  end

  def self.goal_types
    GoalType.constants.map { |const| GoalType.const_get(const)[:name] }
  end

  def time_left
    if started_date > Time.zone.now
     Goal::Messages::Not_Started
    elsif end_date < Time.zone.now
      nil
    elsif started_date < Time.zone.now
      distance_of_time_in_words(Time.zone.now, end_date).titleize + ' Left'
    end
  end

  def time_elapsed
    if started_date < Time.zone.now && end_date > Time.zone.now
      distance_of_time_in_words(Time.zone.now, started_date).titleize + ' Elapsed - '
    end
  end

  def time_elapsed_percentage
    _time_elapsed = started_date <= Time.zone.now ? Time.zone.now - started_date : 0
    _time_elapsed*100/Float(end_date - started_date)
  end

  def expert_advices
    master_keywords = MasterKeyword.where("keyword IN(?)", self.description.gsub(/[^a-zA-Z0-9 ]/i, '').split(' '))
    GoalAdvice.where("goal_type = ? AND id IN(?)", self.goal_type, master_keywords.map(&:goal_advice_id)).order('updated_at DESC').limit(5)
  end

  def icon_path(user_profile)
    "/assets/advisor_icons/assistant/#{user_profile.present? ? (user_profile.assistant_icon_img) : ("assistant_male_d6c4c2_ffd8b6")}.png"
  end

  def is
    SG::ASSISTANT
  end

  def share_description
    "Goal - #{description}"
  end

  def action
    self.completed? ? (I18n.t(:completed)):(I18n.t(:added))
  end

  def share_action
    "Shared"
  end

  def set_share_score
    Goal::Kudos_Pts::Share_Goal
  end

  def set_kudos_goal_completed_score
    Goal::Kudos_Pts::Complete_Goal
  end
  
end
