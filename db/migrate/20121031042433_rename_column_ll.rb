class RenameColumnLl < ActiveRecord::Migration
  def change
    rename_column :location_lists, :type, :loc_list_type
    rename_column :external_user_activities, :type, :ext_activity_type
  end
  
end
