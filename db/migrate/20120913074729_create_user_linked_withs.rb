class CreateUserLinkedWiths < ActiveRecord::Migration
  def change
    create_table :user_linked_withs do |t|
      t.integer :user_id
      t.integer :social_media_id
      t.datetime :deleted_at
      t.timestamps
    end
  end
end
