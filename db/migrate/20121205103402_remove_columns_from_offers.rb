class RemoveColumnsFromOffers < ActiveRecord::Migration
  def up
    remove_column :offers, :redemption_neighborhood
    remove_column :offers, :redemption_country
    remove_column :offers, :redemption_street_address1
    remove_column :offers, :redemption_street_address2
    remove_column :offers, :redemption_city
    remove_column :offers, :redemption_state
    remove_column :offers, :redemption_zip_code
    remove_column :offers, :redemption_lat
    remove_column :offers, :redemption_long
    remove_column :offers, :redemption_phone_number
    remove_column :offers, :number_sold
    remove_column :offers, :value_currency
    remove_column :offers, :value_amount
    remove_column :offers, :price_currency
    remove_column :offers, :price_amount
    remove_column :offers, :discount_currency
    remove_column :offers, :discount_amount
    remove_column :offers, :discount_percent
    remove_column :offers, :trend_score
    remove_column :offers, :woe_id
  end

  def down
    add_column :offers, :redemption_neighborhood, :string
    add_column :offers, :redemption_country, :string
    add_column :offers, :redemption_street_address1, :string
    add_column :offers, :redemption_street_address2, :string
    add_column :offers, :redemption_city, :string
    add_column :offers, :redemption_state, :string
    add_column :offers, :redemption_zip_code, :string
    add_column :offers, :redemption_lat, :float
    add_column :offers, :redemption_long, :float
    add_column :offers, :redemption_phone_number, :string
    add_column :offers, :number_sold, :integer
    add_column :offers, :value_currency, :string
    add_column :offers, :value_amount, :string
    add_column :offers, :price_currency, :string
    add_column :offers, :price_amount, :float
    add_column :offers, :discount_currency, :string
    add_column :offers, :discount_amount, :float
    add_column :offers, :discount_percent, :float
    add_column :offers, :trend_score, :float
    add_column :offers, :woe_id, :integer
  end

end
