class CreateSocialMedia < ActiveRecord::Migration
  def change
    create_table :social_media do |t|
      t.string :name
      t.integer :social_media_id
      t.datetime :deleted_at
      t.timestamps
    end
  end
end
