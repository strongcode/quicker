class RenameLanguagesColumn < ActiveRecord::Migration
  def change
    rename_column :languages, :description, :englishname
    add_column :languages, :spanishname, :string
  end

end
