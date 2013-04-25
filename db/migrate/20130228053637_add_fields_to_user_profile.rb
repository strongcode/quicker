class AddFieldsToUserProfile < ActiveRecord::Migration
  def change
    add_column :user_profiles, :show_sidekick_guide, :boolean, :default => true
    add_column :user_profiles, :show_insider_guide, :boolean, :default => true
    add_column :user_profiles, :show_assistant_guide, :boolean, :default => true
    add_column :user_profiles, :show_dashboard_guide, :boolean, :default => true
  end
end
