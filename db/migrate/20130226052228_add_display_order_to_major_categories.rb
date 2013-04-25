class AddDisplayOrderToMajorCategories < ActiveRecord::Migration
  def up
    add_column :major_categories, :display_order, :integer

    MajorCategory.all.each do |category|
      case category.major_category_name
      when "lifestyle"
        category.display_order = 1
      when "shopping"
        category.display_order = 2
      when "food"
        category.display_order = 3
        category.english_version = "food & beverages"
      when "travel"
        category.display_order = 4
      when "business"
        category.display_order = 5
        category.english_version = "business & services"
      end
      category.save
    end
  end

  def down
    remove_column :major_categories, :display_order
  end
  
end
