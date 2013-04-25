class AddColumnToUserProfiles < ActiveRecord::Migration
  def change
    add_column :photos, :old_image, :string
  end
end
