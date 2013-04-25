class RenameColumnLocations < ActiveRecord::Migration
  def change
    rename_column :user_preferences, :service_on_sidekick, :business_on_sidekick
  end
end
