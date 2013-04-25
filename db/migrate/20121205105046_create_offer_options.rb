class CreateOfferOptions < ActiveRecord::Migration
  def change
    create_table :offer_options do |t|
      t.string :redemption_neighborhood
      t.string :redemption_country
      t.string :redemption_street_address1
      t.string :redemption_street_address2
      t.string :redemption_city
      t.string :redemption_state
      t.string :redemption_zip_code
      t.float  :redemption_lat
      t.float :redemption_lng
      t.string :redemption_phone_number
      t.integer :number_sold
      t.string :value_currency
      t.float :value_amount
      t.string :price_currency
      t.float :price_amount
      t.string :discount_currency
      t.float :discount_amount
      t.string :discount_percent
      t.float :trend_score
      t.string :woeid
      t.integer :offer_id
      t.timestamps
    end
  end
end

 