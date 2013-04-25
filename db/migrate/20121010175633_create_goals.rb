class CreateGoals < ActiveRecord::Migration
  def change
    create_table :goals do |t|
      t.string :goal_type
      t.text :description
      t.datetime :started_date
      t.datetime :end_date
      t.datetime :ended_date
      t.integer :completed, :default => Goal::NOT_COMPLETED, :limit => 1
      t.integer :status_percentage, :default => 0, :limit => 3
      t.integer :user_id
      t.string :feeds
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
