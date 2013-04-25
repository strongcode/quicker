class RemoveYelpFieldsFromOffers < ActiveRecord::Migration
  def up
    remove_column :offers, :yelp_id
    remove_column :offers, :yelp_reviews_count
    remove_column :offers, :yelp_rating
    add_column :offers, :snapgadget_category_id, :integer
    change_column :offers, :category_id, :string
    change_column :offers, :deal_id, :string
    remove_column :offers, :deal_highlights
    change_column :offer_options, :value_amount, :string
    change_column :offer_options, :price_amount, :string
    change_column :offer_options, :discount_amount, :string
    add_column :offers, :short_announcement_title, :string
  end

  def down
    remove_column :offers, :short_announcement_title
    remove_column :offers, :snapgadget_category_id
    add_column :offers, :yelp_rating, :string
    add_column :offers, :yelp_reviews_count, :string
    add_column :offers, :yelp_id, :string

    change_column :offers, :category_id, :integer
    change_column :offers, :deal_id, :integer
    add_column :offers, :deal_highlights, :string
    change_column :offer_options, :value_amount, :float
    change_column :offer_options, :price_amount, :float
    change_column :offer_options, :discount_amount, :float
  end
  
end


