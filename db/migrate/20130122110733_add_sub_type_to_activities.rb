class AddSubTypeToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :sub_type, :string
  end
end
