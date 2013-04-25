class AddStreetAddressToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :street_address, :string
    add_column :locations, :city, :string
  end
end
