class AddScoreToOffers < ActiveRecord::Migration
  def change
    add_column :offers, :score, :integer, :default => 0
  end

end
