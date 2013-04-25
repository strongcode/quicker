class PopulateSgPages < ActiveRecord::Migration
  def up
    Rake::Task['populate:sg_page'].invoke
  end

  def down
  end
end
