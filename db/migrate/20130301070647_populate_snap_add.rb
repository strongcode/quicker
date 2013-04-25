class PopulateSnapAdd < ActiveRecord::Migration
  def up
    Rake::Task['db:populate_snap_add'].invoke
    offer_zip_deal = OfferZipDeal.new(:zipcode => "89109", :latitude => '36.11', :longitude => '-115.12',
      :groupon_division => 'Las-Vegas', :livingsocial_division => '30')
    offer_zip_deal.save
  end

  def down
  end
  
end
