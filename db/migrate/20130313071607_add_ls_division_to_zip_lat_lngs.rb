class AddLsDivisionToZipLatLngs < ActiveRecord::Migration
  def change
    add_column :zip_lat_lngs, :ls_division, :string
  end
end
