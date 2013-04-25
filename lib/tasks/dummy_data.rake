namespace 'dummy' do
  desc 'populate dummy data'
  task 'data' => :environment do
    #Goal::GoalType.constants.map { |const| Goal::GoalType.const_get(const)[:name] }.each { |goal_type|
      ga = GoalAdvice.create :goal_type => Goal::GoalType::FITNESS[:name], :expert_advice_added => Date.current,
                        :expert_advice_description => "5 ways to improve your 5k speed.",
                        :expert_advice_url => "http://www.active.com/running/Articles/5_ways_to_improve_Your_5k_speed.htm"
      p ga.errors.full_messages
      p ga.inspect
    #}
  end
end