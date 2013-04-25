class CreateTrackers < ActiveRecord::Migration
  def change
    create_table :trackers do |t|
      t.string :trackable_type
      t.integer :trackable_id
      t.integer :user_id

      t.timestamps
    end
  end
end
