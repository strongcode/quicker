class AddDealCategoriesToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :deal_categories, :string  	
  end
end
