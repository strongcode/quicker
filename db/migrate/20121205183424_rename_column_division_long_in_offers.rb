class RenameColumnDivisionLongInOffers < ActiveRecord::Migration
  def up
    rename_column :offers, :division_long, :division_lng
  end

  def down
    rename_column :offers, :division_lng, :division_long
  end
end
