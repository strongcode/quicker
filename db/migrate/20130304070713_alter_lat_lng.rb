class AlterLatLng < ActiveRecord::Migration
  def up
    change_column :locations, :latitude, :string
    change_column :locations, :longitude, :string
  end

  def down
  end
    
end
