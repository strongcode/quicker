class ChangeDefaultKudosPointsForUsers < ActiveRecord::Migration
  def up
    change_column_default :users, :kudos_points, 0
    change_column_default :activities, :kudos_points, 0
  end
end
