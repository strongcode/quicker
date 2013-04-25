class AddIconFieldsToUserProfile < ActiveRecord::Migration
  def change
    add_column :user_profiles, :insider_icon_img, :string
    add_column :user_profiles, :sidekick_icon_img, :string
    add_column :user_profiles, :assistant_icon_img, :string
  end
end

