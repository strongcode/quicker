class CreateLocationLists < ActiveRecord::Migration
  def change
    create_table :location_lists do |t|
      t.integer :user_id
      t.string :name
      t.string :type
      t.timestamps
    end
  end
end
