class ChangeColumnsLatLng < ActiveRecord::Migration
  def up
    change_column :locations, :latitude, :decimal, :precision => 14, :scale => 14
    change_column :locations, :longitude, :decimal, :precision => 14, :scale => 14
  end

  def down
    change_column :locations, :latitude, :float
    change_column :locations, :longitude, :float
  end
end
