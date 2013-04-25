class CreateLivingSocialExternalCategories < ActiveRecord::Migration
  def change
    create_table :living_social_external_categories do |t|
      t.string  :living_social_category_id
      t.integer :snapgadget_category_id
      t.timestamps
    end
  end
end
