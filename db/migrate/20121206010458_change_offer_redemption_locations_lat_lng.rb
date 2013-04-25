class ChangeOfferRedemptionLocationsLatLng < ActiveRecord::Migration
  def up
    change_column :offer_redemption_locations, :redemption_lat, :string
    change_column :offer_redemption_locations, :redemption_lng, :string
  end

  def down
    change_column :offer_redemption_locations, :redemption_lng, :float
    change_column :offer_redemption_locations, :redemption_lat, :float
  end
end
