class ChangeDataTypeOfNotesInGoals < ActiveRecord::Migration
  def up
    change_column :goals, :notes, :text
  end

  def down
    change_column :goals, :notes, :string
  end
end
