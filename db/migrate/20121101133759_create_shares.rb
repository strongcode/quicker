class CreateShares < ActiveRecord::Migration
  def change
    create_table :shares do |t|
      t.integer :user_id
      t.string :shareable_type
      t.string :shareable_id
      t.text :comment
      t.string :status
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
