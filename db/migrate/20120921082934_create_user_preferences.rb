class CreateUserPreferences < ActiveRecord::Migration
  def change
    create_table :user_preferences do |t|
      t.integer :user_id
      t.integer :landing_page_id
      t.integer :offer_category_1
      t.integer :offer_category_2
      t.integer :offer_category_3
      t.integer :suggestion_category_1
      t.integer :suggestion_category_2
      t.integer :suggestion_category_3
      t.integer :you_deserve_it_category
      t.boolean :repeat_experiences
      t.boolean :life_style_on_sidekick
      t.boolean :shopping_on_sidekick
      t.boolean :food_on_sidekick
      t.boolean :services_on_sidekick
      t.boolean :my_and_friends_data_on_sidekick
      t.string :question_1
      t.string :question_2
      t.timestamps
    end
  end
end
