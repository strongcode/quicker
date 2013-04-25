class AddKeywordsToGoalAdvice < ActiveRecord::Migration
  def change
    add_column :goal_advices, :keywords, :string
    add_column :goal_advices, :snapgadget_expert, :boolean, :default => false
    remove_column :goal_advices, :expert_advice_added
  end
  
end
