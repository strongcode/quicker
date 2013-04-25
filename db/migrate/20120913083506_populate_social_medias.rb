class PopulateSocialMedias < ActiveRecord::Migration
  def up
    Rake::Task['populate:social_media'].invoke
  end

  def down
  end
  
end
