class PopulateGoalAdviceRakeTasks < ActiveRecord::Migration
  def up
    Rake::Task['populate:goal_advice'].invoke
    Rake::Task['populate:master_keyword'].invoke
  end

  def down
    MasterKeyword.destroy_all
    GoalAdvice.destroy_all
  end
end
