class RenameOldTableToNewTable < ActiveRecord::Migration
  def change
    rename_table :external_categories, :groupon_external_categories
  end
end
