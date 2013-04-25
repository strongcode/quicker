class RenameColumns < ActiveRecord::Migration
  def change
    rename_column :user_preferences, :life_style_on_sidekick, :lifestyle_on_sidekick
    rename_column :user_preferences, :services_on_sidekick, :service_on_sidekick
    rename_column :user_preferences, :my_and_friends_data_on_sidekick, :friend_on_sidekick
  end

end
