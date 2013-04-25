class AddColumnDeletedAtToLocationLinkedLocLists < ActiveRecord::Migration
  def change
    add_column :location_linked_loc_lists, :deleted_at, :datetime
  end
end
