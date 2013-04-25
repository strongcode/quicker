class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :WOEID
      t.string :google_maps_cid
      t.string :foursquare_venue_id
      t.string :yelp_id
      t.float :latitude
      t.float :longtitude
      t.string :name
      t.string :full_address
      t.string :phone
      t.string :sg_major_category
      t.string :sg_minor_category
      t.timestamps
    end
  end
end
