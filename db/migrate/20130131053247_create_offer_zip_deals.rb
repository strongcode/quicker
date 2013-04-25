class CreateOfferZipDeals < ActiveRecord::Migration
  def change
    create_table :offer_zip_deals do |t|
      t.string :zipcode
      t.string :latitude
      t.string :longitude
      t.string :groupon_division
      t.string :livingsocial_division
      t.timestamps
    end
  end
end
