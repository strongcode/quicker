class AddWoeIdToUserProfiles < ActiveRecord::Migration
  def change
    add_column :user_profiles, :woe_id, :string
  end
end
