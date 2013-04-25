class RenameLocationsColumn < ActiveRecord::Migration
  
  def change
    rename_column :locations, :longtitude, :longitude
  end

end
