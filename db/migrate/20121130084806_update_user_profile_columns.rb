class UpdateUserProfileColumns < ActiveRecord::Migration
  def up
    rename_column :user_profiles, :city, :location_name
    add_column :user_profiles, :location_street, :string
    add_column :user_profiles, :location_city, :string
    add_column :user_profiles, :location_state, :string
    add_column :user_profiles, :location_zipcode, :string
  end

  def down
    remove_column :user_profiles, :location_zipcode
    remove_column :user_profiles, :location_state
    remove_column :user_profiles, :location_city
    remove_column :user_profiles, :location_street
    rename_column :user_profiles, :location_name, :city
  end
end
