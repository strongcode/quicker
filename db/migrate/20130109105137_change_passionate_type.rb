class ChangePassionateType < ActiveRecord::Migration
  def up
    change_column :passionates, :passionate_type, :integer
    rename_column :passionates, :passionate_type, :snapgadget_category_id
  end

  def down
    rename_column :passionates, :snapgadget_category_id, :passionate_type
    change_column :passionates, :passionate_type, :string
  end
end
