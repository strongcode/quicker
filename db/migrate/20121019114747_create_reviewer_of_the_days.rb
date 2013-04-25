class CreateReviewerOfTheDays < ActiveRecord::Migration
  def change
    create_table :reviewer_of_the_days do |t|
      t.string :zip_code
      t.integer :user_id
      t.timestamps
    end
  end
end
