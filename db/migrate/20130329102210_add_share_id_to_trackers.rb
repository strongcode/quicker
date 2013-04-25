class AddShareIdToTrackers < ActiveRecord::Migration
  def change
    add_column :trackers, :shared_from_id, :integer
  end
end
