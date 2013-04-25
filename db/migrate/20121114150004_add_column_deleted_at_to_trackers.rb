class AddColumnDeletedAtToTrackers < ActiveRecord::Migration
  def change
    add_column :trackers, :deleted_at, :datetime
  end
end
