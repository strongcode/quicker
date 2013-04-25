class AddColumnNotesToGoals < ActiveRecord::Migration
  def change
    add_column :goals, :notes, :string
  end
end
