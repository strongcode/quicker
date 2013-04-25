class ChnageColumnsLocations < ActiveRecord::Migration
  def up
    change_column :locations, :latitude, :float
    change_column :locations, :longitude, :float
  end
  
end
