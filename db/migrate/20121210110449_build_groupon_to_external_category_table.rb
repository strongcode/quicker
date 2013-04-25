class BuildGrouponToExternalCategoryTable < ActiveRecord::Migration
  def up
    Rake::Task['db:populate_groupon_category'].invoke
  end

  def down
  end
end
