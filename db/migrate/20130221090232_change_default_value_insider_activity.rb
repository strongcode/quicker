class ChangeDefaultValueInsiderActivity < ActiveRecord::Migration
  def up
    change_column_default :insider_activities, :no_of_times_presented, 0
  end
  
end
