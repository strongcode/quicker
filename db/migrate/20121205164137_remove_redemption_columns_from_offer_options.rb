class RemoveRedemptionColumnsFromOfferOptions < ActiveRecord::Migration

  def up
    remove_column :offer_options, :redemption_neighborhood
    remove_column :offer_options, :redemption_country
    remove_column :offer_options, :redemption_street_address1
    remove_column :offer_options, :redemption_street_address2
    remove_column :offer_options, :redemption_city
    remove_column :offer_options, :redemption_state
    remove_column :offer_options, :redemption_zip_code
    remove_column :offer_options,  :redemption_lat
    remove_column :offer_options, :redemption_lng
    remove_column :offer_options, :redemption_phone_number
    remove_column :offer_options, :woeid
  end

  def down
    add_column :offer_options, :redemption_neighborhood, :string
    add_column :offer_options, :redemption_country, :string
    add_column :offer_options, :redemption_street_address1, :string
    add_column :offer_options, :redemption_street_address2, :string
    add_column :offer_options, :redemption_city, :string
    add_column :offer_options, :redemption_state, :string
    add_column :offer_options, :redemption_zip_code, :string
    add_column :offer_options,  :redemption_lat, :float
    add_column :offer_options, :redemption_lng, :float
    add_column :offer_options, :redemption_phone_number, :string
    add_column :offer_options, :woeid, :string
  end

end
