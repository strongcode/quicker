class CreateLocationLinkedLocLists < ActiveRecord::Migration
  def change
    create_table :location_linked_loc_lists do |t|
      t.integer :location_id
      t.integer :location_list_id
      t.timestamps
    end
  end
end
