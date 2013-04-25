class AddNumberSoldAndTrendScoreToOffers < ActiveRecord::Migration
  def change
    add_column :offers, :number_sold, :integer
    add_column :offers, :trend_score, :float
  end
end
