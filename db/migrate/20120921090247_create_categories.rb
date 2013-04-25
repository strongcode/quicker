class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :deal_site_category
      t.string :major_category
      t.string :sg_category
      t.text :description
      t.string :photo
      t.timestamps
    end
  end
end
