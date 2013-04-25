class RenameColumnInPassionates < ActiveRecord::Migration
  def change
    rename_column :passionates, :type, :passionate_type
  end

end
