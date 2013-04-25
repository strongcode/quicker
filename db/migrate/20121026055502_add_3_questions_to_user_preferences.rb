class Add3QuestionsToUserPreferences < ActiveRecord::Migration
  def change
    add_column :user_preferences, :question_3, :string
    add_column :user_preferences, :question_4, :string
    add_column :user_preferences, :question_5, :string
  end
end
