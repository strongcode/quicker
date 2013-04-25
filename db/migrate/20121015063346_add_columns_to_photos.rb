class AddColumnsToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :imageable_id, :integer
    add_column :photos, :imageable_type, :string
    remove_column :photos, :user_profile_id
  end
end
