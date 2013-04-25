class AddStateToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :state, :string, :default => 'active'
  end
end
