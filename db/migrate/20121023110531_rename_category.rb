class RenameCategory < ActiveRecord::Migration
  def change
    rename_column :categories, :sg_category, :minor_category
  end
end
