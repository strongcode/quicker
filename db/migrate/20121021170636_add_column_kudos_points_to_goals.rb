class AddColumnKudosPointsToGoals < ActiveRecord::Migration
  def change
    add_column :goals, :kudos_points, :integer
  end
end
