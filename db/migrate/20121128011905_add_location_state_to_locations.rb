class AddLocationStateToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :location_state, :string
  end
end
