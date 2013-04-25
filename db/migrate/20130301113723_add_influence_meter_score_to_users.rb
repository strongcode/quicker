class AddInfluenceMeterScoreToUsers < ActiveRecord::Migration
  def change
    add_column :users, :influence_meter_score, :integer, :default => 1
  end
end
