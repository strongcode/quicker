class AddTravelOnSidekickToUserPreferences < ActiveRecord::Migration
  def change
    add_column :user_preferences, :travel_on_sidekick, :boolean
  end
end
