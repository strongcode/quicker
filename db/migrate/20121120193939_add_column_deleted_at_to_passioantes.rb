class AddColumnDeletedAtToPassioantes < ActiveRecord::Migration
  def change
    add_column :passionates, :deleted_at, :datetime
  end
end
