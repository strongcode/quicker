class CreateMajorCategories < ActiveRecord::Migration
  def up
    create_table :major_categories do |t|
      t.string :major_category_name
      t.string :english_version
      t.string :spanish_version
      t.timestamps
    end

    MajorCategory.create(:major_category_name => 'business', :english_version => 'business and services', :spanish_version => 'Negocios Y Servicios')
    MajorCategory.create(:major_category_name => 'food',     :english_version => 'food and beverages', :spanish_version => 'Comidas Y Bebidas')
    MajorCategory.create(:major_category_name => 'lifestyle', :english_version => 'lifestyle', :spanish_version => 'Estilo De Vida')
    MajorCategory.create(:major_category_name => 'shopping', :english_version => 'shopping', :spanish_version => 'Compras')
    MajorCategory.create(:major_category_name => 'travel', :english_version => 'travel', :spanish_version => 'Viajar')
  end

  def down
    drop_table :major_categories
  end

  
end
