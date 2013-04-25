class AddColumnsToUserProfile < ActiveRecord::Migration
  def change
    add_column :user_profiles, :offer_category_1, :integer
    add_column :user_profiles, :offer_category_2, :integer
    add_column :user_profiles, :offer_category_3, :integer
    add_column :user_profiles, :suggestion_category_1, :integer
    add_column :user_profiles, :suggestion_category_2, :integer
    add_column :user_profiles, :suggestion_category_3, :integer
    add_column :user_profiles, :you_deserve_it_category, :integer
    add_column :user_profiles, :repeat_experiences, :boolean, :default => false
    add_column :user_profiles, :lifestyle_on_sidekick, :boolean, :default => false
    add_column :user_profiles, :shopping_on_sidekick, :boolean, :default => false
    add_column :user_profiles, :food_on_sidekick, :boolean, :default => false
    add_column :user_profiles, :business_on_sidekick, :boolean, :default => false
    add_column :user_profiles, :travel_on_sidekick, :boolean, :default => false
    add_column :user_profiles, :friends_on_sidekick, :boolean, :default => false
    add_column :user_profiles, :question_1, :string
    add_column :user_profiles, :question_2, :string
    add_column :user_profiles, :question_3, :string
    add_column :user_profiles, :question_4, :string
    add_column :user_profiles, :question_5, :string
    add_column :user_profiles, :landing_page_id, :integer
  end
end