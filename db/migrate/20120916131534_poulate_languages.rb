class PoulateLanguages < ActiveRecord::Migration
  def up
    Rake::Task['populate:languages'].invoke
  end

  def down
    Language.destroy_all
  end
end
