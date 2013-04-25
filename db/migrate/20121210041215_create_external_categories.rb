class CreateExternalCategories < ActiveRecord::Migration
  def change
    create_table :external_categories do |t|
      t.string  :groupon_category_id
      t.integer :snapgadget_category_id
      t.timestamps
    end
  end
end
