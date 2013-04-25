class AddIconPathToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :icon_path, :string, :default => 'default-image.png'
  end
end
