class CreateOffers < ActiveRecord::Migration
  def change
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
