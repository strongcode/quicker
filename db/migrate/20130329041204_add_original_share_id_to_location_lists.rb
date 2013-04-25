class AddOriginalShareIdToLocationLists < ActiveRecord::Migration
  def change
    add_column :location_lists, :original_share_id, :integer
  end
end
