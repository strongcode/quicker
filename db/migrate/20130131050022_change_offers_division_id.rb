class ChangeOffersDivisionId < ActiveRecord::Migration
  def up
    change_column :offers, :division_id, :string
  end

  def down
    change_column :offers, :division_id, :integer
  end
  
end
