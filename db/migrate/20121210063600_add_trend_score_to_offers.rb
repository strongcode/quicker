class AddTrendScoreToOffers < ActiveRecord::Migration
  def change
    add_column :offers, :trend_score, :float
  end
end
