class CreatePassionates < ActiveRecord::Migration
  def change
    create_table :passionates do |t|
      t.integer :user_id
      t.string  :name
      t.string  :type
      t.integer :location_id
      t.text    :passionate_text
      t.string  :url
      t.integer :kudos_points, :null => false, :default => 0
      t.timestamps
    end
  end
end
