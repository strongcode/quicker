require 'csv'

namespace 'db' do
  desc 'removes all existing offers and import offers data from csv file'
  task 'import_offers' => :environment do
    path = "lib/data/OffersTableExampleModified.csv"
    Offer.destroy_all # To remove all existing offers
    csv_table = CSV.table(path, { headers: true, converters: nil, header_converters: :symbol })
    headers = csv_table.headers
    csv_table.each do|row|
      row.headers.each{ |cell| row[cell] = row[cell].to_s.strip }

      offer = Offer.new(:deal_source => row[:type], :deal_id => row[:dealid], :merchant_name => row[:merchantname], 
        :category_id => row[:snapgadgetdealcategories], :deal_type => row[:dealtype],
        :merchant_type => row[:merchanttype],
        :national_deal => row[:nationaldeal].present? ? true : false,
        :division_id => row[:divisionid],
        :division_lat => row[:divisionlat].to_s, :division_long => row[:divisionlong].to_s,
        :large_image_url => row[:largeimageurl], :small_image_url => row[:smallimageurl], :status => row[:status],
        :deal_url => row[:dealurl], :deal_header => row[:dealheader], :deal_highlights => row[:dealhighlights],
        :deal_start => row[:dealstart], :deal_updated => row[:dealupdated], :deal_end => row[:dealend],
        :deal_tipped => row[:dealtipped], :deal_tipped_at => row[:dealtippedat],
        :redemption_neighborhood => row[:redemptionneighborhood],
        :redemption_country => row[:redemptioncountry], :redemption_street_address1 => row[:redemptionstreetaddress1],
        :redemption_street_address2 => row[:redemptionstreetaddress2], :redemption_city => row[:redemptioncity],
        :redemption_state => row[:redemptionstate], :redemption_zip_code => row[:redemptionzipcode],
        :redemption_lat => row[:redemptionlat].to_s, :redemption_long => row[:redemptionlong].to_s,
        :redemption_phone_number => row[:redemptionphonenumber], :value_currency => row[:valuecurrency],
        :value_amount => row[:valueamount], :price_currency => row[:pricecurrency], :price_amount => row[:priceamount],
        :discount_currency => row[:discountcurrency], :discount_amount => row[:discountamount],
        :discount_percent => row[:discountpercent], :yelp_id => row[:yelpid], :yelp_reviews_count => row[:yelpewviewscount],
        :yelp_rating => row[:yelprating], :number_sold => row[:numbersold].gsub(",","").to_i)
      offer.local_deal = !(offer.national_deal)
      offer.save
      if(row[:snapgadgetdealcategories].present? && row[:dealcategories].present?)
        p "in inner if condition to update category table's dealcategory details"
        category = Category.find(row[:snapgadgetdealcategories])
        if category.deal_categories.blank?
          category.deal_categories = row[:dealcategories]
          category.save
        elsif !category.deal_categories.include?(row[:dealcategories])
          category.deal_categories += ";#{row[:dealcategories]}"          
          category.save
        end
      end
    end

  end

  task 'populate_groupon_category' => :environment do
    path = "lib/data/groupon_snapgadget.csv"
    csv_table = CSV.table(path, { headers: true, converters: nil, header_converters: :symbol })
    headers = csv_table.headers
    csv_table.each do|row|
      row.headers.each{ |cell| row[cell] = row[cell].to_s.strip }
      external_category = GrouponExternalCategory.new(:groupon_category_id => row[:groupon_category_id], :snapgadget_category_id => row[:snapgadgetcategoryid])
      if external_category.save
        p external_category.groupon_category_id
        p external_category.snapgadget_category_id
      end
    end

  end

  desc "populate OfferZipDeals table"

  task 'populate_offer_zip_table' => :environment do
    path = "lib/data/offer_zip_deals.csv"
    csv_table = CSV.table(path, {headers: true, converters: nil, header_converters: :symbol})
    headers = csv_table.headers
    csv_table.each do|row|
      row.headers.each{ |cell| row[cell] = row[cell].to_s.strip }
      offer_zip = OfferZipDeal.new(:zipcode => row[:zipcode], :latitude => row[:latitude], :longitude => row[:longitude], :groupon_division => row[:groupon_division], :livingsocial_division => row[:livingsocial_division])
      offer_zip.save
    end 
  end

  desc 'Populate offers of las vegus and others'
  task 'populate_offers' => :environment do
    Offer.populate_offers
  end

  desc 'Populate SnapItUp'
  task 'populate_snap_add' => :environment do
    path = "lib/data/SnapAdd.csv"
    csv_table = CSV.table(path, {headers: true, converters: nil, header_converters: :symbol})
    headers = csv_table.headers
    csv_table.each do|row|
      row.headers.each{ |cell| row[cell] = row[cell].to_s.strip }
      offer = Offer.new(:deal_source => row[:deal_source], :snapgadget_category_id => row[:snapgadget_category_id],
        :merchant_name => row[:merchant_name], :redemption_location => row[:redemption_location],
        :division_id => row[:division_id], :deal_header => row[:deal_header],
        :large_image_url => row[:large_image_url], :deal_url => row[:deal_url])
      offer.save
    end 
  end

  desc 'Populate predefined members'
  task 'populate_member_emails' => :environment do
    path = "lib/data/membership_status.csv"
    csv_table = CSV.table(path, {headers: true, converters: nil, header_converters: :symbol})
    headers = csv_table.headers
    csv_table.each do|row|
      row.headers.each{ |cell| row[cell] = row[cell].to_s.strip }
      membership_email = MembershipStatusEmail.new(:email => row[:email], :membership_status => row[:membership_status].downcase)
      membership_email.save
    end
  end

end