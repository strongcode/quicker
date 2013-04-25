class CreateZipLatLngs < ActiveRecord::Migration
  def change
    create_table :zip_lat_lngs do |t|
      t.string :zipcode
      t.string :primary_city
      t.string :state
      t.string :latitude
      t.string :longitude
      t.string :division
      t.timestamps
    end
  end
end
