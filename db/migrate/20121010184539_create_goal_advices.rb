class CreateGoalAdvices < ActiveRecord::Migration
  def change
    create_table :goal_advices do |t|
      t.string :goal_type
      t.text :expert_advice_description
      t.string :expert_advice_url
      t.datetime :expert_advice_added
      t.string :state
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
