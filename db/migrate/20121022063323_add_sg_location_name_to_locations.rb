class AddSgLocationNameToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :sg_location_name, :string
    add_column :locations, :kudos_points, :integer
    add_column :locations, :url, :string
  end
end
