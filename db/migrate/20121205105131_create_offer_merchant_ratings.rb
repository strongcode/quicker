class CreateOfferMerchantRatings < ActiveRecord::Migration
  def change
    create_table :offer_merchant_ratings do |t|
      t.string :merchant_rating_site
      t.string :merchant_rating_score
      t.string :merchant_rating_reviews
      t.integer :offer_id
      t.timestamps
    end
    add_column :offers, :redemption_location, :string
  end
end
