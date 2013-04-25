class CreateDealSites < ActiveRecord::Migration
  def change
    create_table :deal_sites do |t|
      t.string  :name
      t.string  :deal_site_type
      t.string  :url
      t.string  :deal_site_params
      t.string  :deal_site_key
      t.boolean :deal_site_status, :default => false
      t.integer :frequency
      t.datetime :last_datetime_run
      t.timestamps
    end
  end
end
