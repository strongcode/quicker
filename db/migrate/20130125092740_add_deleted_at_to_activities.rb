class AddDeletedAtToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :deleted_at, :datetime
    add_column :categories, :deleted_at, :datetime
  end
end
