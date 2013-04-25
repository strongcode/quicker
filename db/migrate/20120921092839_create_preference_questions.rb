class CreatePreferenceQuestions < ActiveRecord::Migration
  def change
    create_table :preference_questions do |t|
      t.string :title
      t.timestamps
    end
  end
end
