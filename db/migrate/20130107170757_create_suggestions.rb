class CreateSuggestions < ActiveRecord::Migration
  def change
    create_table :suggestions do |t|
      t.string :name
      t.datetime :when
      t.integer :snapgadget_category_id
      t.integer :location_id
      t.integer :user_id
      t.text :comments, :limit => 2000
      t.string :url
      t.integer :kudos_points
      t.timestamps
    end
  end
end
