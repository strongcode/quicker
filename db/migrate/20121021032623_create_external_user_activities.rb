class CreateExternalUserActivities < ActiveRecord::Migration
  def change
    create_table :external_user_activities do |t|
      t.integer :user_id
      t.string  :source
      t.string  :type
      t.text    :description
      t.string  :location
      t.integer :location_id
      t.timestamps
    end
  end
end
