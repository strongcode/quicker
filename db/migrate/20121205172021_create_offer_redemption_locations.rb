class CreateOfferRedemptionLocations < ActiveRecord::Migration
  def change
    create_table :offer_redemption_locations do |t|
      t.string :redemption_neighborhood
      t.string :redemption_country
      t.string :redemption_street_address1
      t.string :redemption_street_address2
      t.string :redemption_city
      t.string :redemption_state
      t.string :redemption_zip_code
      t.float :redemption_lat
      t.float :redemption_lng
      t.string :redemption_phone_number
      t.string :woeid
      t.integer :offer_id
      t.integer :offer_option_id
      t.timestamps
    end
  end
end
