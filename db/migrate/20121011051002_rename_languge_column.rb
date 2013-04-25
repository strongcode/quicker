class RenameLangugeColumn < ActiveRecord::Migration
  def change
    rename_column :languages, :englishname,:description
  end
end
