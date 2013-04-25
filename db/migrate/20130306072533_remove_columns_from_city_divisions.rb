class RemoveColumnsFromCityDivisions < ActiveRecord::Migration
  def up
    remove_column :city_divisions, :latitude
    remove_column :city_divisions, :longitude
    remove_column :city_divisions, :zipcode
  end

  def down
    add_column :city_divisions, :latitude, :string
    add_column :city_divisions, :longitude, :string
    add_column :city_divisions, :zipcode, :string
  end
end
