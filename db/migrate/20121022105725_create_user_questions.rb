class CreateUserQuestions < ActiveRecord::Migration
  def change
    create_table :user_questions do |t|
      t.integer :user_id
      t.string :question_1
      t.string :question_2
      t.string :question_3
      t.string :question_4
      t.string :question_5
      t.timestamps
    end
  end
end
