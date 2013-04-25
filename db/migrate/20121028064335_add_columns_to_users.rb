class AddColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :membership_type, :string
    add_column :users, :reviewer_status, :string
    add_column :users, :kudos_points, :integer, :null => false, :default => 0
    add_column :users, :ambasador_status, :string
  end
end
