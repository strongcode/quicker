class RecreateOffers < ActiveRecord::Migration
  def up
    drop_table :offers
    create_table :offers do |t|
      t.string :deal_source
      t.integer :deal_id
      t.string :merchant_name 
      t.integer :category_id
      t.string :deal_type
      t.string :merchant_type
      t.boolean :national_deal
      t.boolean :local_deal
      t.integer :division_id
      t.decimal :division_lat, :precision => 12, :scale => 8
      t.decimal :division_long, :precision => 12, :scale => 8
      t.string :large_image_url
      t.string :small_image_url
      t.string :status
      t.string :deal_url
      t.string :deal_header
      t.text :deal_highlights
      t.datetime :deal_start
      t.datetime :deal_updated
      t.datetime :deal_end
      t.boolean :deal_tipped
      t.datetime :deal_tipped_at
      t.string :redemption_neighborhood
      t.string :redemption_country
      t.string :redemption_street_address1
      t.string :redemption_street_address2
      t.string :redemption_city
      t.string :redemption_state
      t.string :redemption_zip_code
      t.decimal :redemption_lat, :precision => 12, :scale => 8
      t.decimal :redemption_long, :precision => 12, :scale => 8
      t.string :redemption_phone_number
      t.string :value_currency
      t.string :value_amount
      t.string :price_currency
      t.string :price_amount
      t.string :discount_currency
      t.string :discount_amount
      t.string :discount_percent
      t.string :yelp_id
      t.string :yelp_reviews_count
      t.string :yelp_rating
      t.string :woe_id
      
      t.timestamps
  	end  	
  end

  def down
    drop_table :offers
    create_table :offers do |t|
      t.string    :deal_source
      t.integer   :external_offer_number
      t.string    :offer_type
      t.datetime  :date_retrieved
      t.datetime  :start_date
      t.datetime  :end_date
      t.string    :status
      t.string    :simple_description
      t.text      :full_description
      t.float     :price
      t.string    :currency
      t.integer   :quantity
      t.integer   :discount
      t.string    :external_category
      t.string    :snapgadget_category
      t.string    :business_name
      t.string    :business_address
      t.string    :business_phone
      t.string    :business_url
      t.string    :largest_near_city
      t.string    :utm
      t.string    :title
      t.datetime  :deleted_at
      t.timestamps
    end
  end
end
