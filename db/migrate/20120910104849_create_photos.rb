class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string  :image
      t.integer :user_profile_id
      t.datetime :deleted_at
      t.timestamps
    end
  end
end
