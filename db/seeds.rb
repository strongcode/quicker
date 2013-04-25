GoalType.constants.map { |const| GoalType.const_get(const)[:name] }.each {|goal_type|
  GoalAdvice.create :goal_type => goal_type, :expert_advice_added => Date.current,
                    :expert_advice_description => "#{goal_type} Description",
                    :expert_advice_url => "http://google.com"
}
