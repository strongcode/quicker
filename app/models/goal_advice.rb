class GoalAdvice < ActiveRecord::Base
  attr_accessible :expert_advice_description, :expert_advice_url, :goal_type, :state, :keywords

  default_scope order('created_at desc')

  acts_as_paranoid

  has_many :master_keywords

  module Status
    ACTIVE = :active
    INACTIVE = :inactive
  end

  validates :goal_type, :state, :expert_advice_description, :expert_advice_url, :presence => true

  validates :goal_type, :inclusion => {:in => Goal::GoalType.constants.map { |const| Goal::GoalType.const_get(const)[:name] }}
  validates :state, :inclusion => {:in => GoalAdvice::Status.constants.map { |const| GoalAdvice::Status.const_get(const).to_s }}

  validates_datetime :deleted_at, :allow_blank => true

  state_machine :state, :initial => Status::ACTIVE do
    event :activate do
      transition Status::INACTIVE => Status::ACTIVE
    end

    event :inactivate do
      transition Status::ACTIVE => Status::INACTIVE
    end
  end
end
