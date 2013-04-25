class CreateSiteActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.string :activitable_type
      t.integer :activitable_id
      t.integer :user_id
      t.datetime :date
      t.string :action
      t.string :description
      t.integer :kudos_points

      t.timestamps
    end
  end
end
