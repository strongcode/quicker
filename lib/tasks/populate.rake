require 'csv'

namespace 'populate' do
  desc 'populate all'
  task 'all' => :environment do
    Rake::Task['populate:sg_page'].invoke
    Rake::Task['populate:social_media'].invoke
    Rake::Task['populate:languages'].invoke
    Rake::Task['populate:locations'].invoke
  end

  desc 'populate sg_page'
  task 'sg_page' => :environment do
    ["sidekick", "insider", "assistant"].each_with_index do |name, index|
      sm = SgPage.find_by_name name
      unless sm
        sm = SgPage.new(:name => name)
        if sm.save
          p sm.name
        end
      end
    end
  end

  desc 'populate social medias'
  task 'social_media' => :environment do
    ["facebook", "twitter", "linkedin","google+", "foursqure", "yelp"].each_with_index do |social_media, index|
      sm = SocialMedia.new(:social_media_id => index+1, :name => social_media)
      if sm.save
        p sm.name
      end
    end
  end

  desc 'Populate Languages'
  task 'languages' => :environment do
    Languages = {
      'English' => 'en',
      'Spanish' => 'es'
    }

    Languages.each_pair do |lang, code|
      language = Language.find_by_language_sid code
      unless language
        my_lang = Language.new(:description => lang, :language_sid => code)
        if my_lang.save
          p "#{my_lang.description} ==> #{my_lang.language_sid}"
        end
      end
    end
  end

  task 'locations' => :environment do
    First = ["Shark Reef Aquarium","12795456", "", "4ba26422f964a5202ff437e3", "http://www.yelp.com/biz/shark-reef-aquarium-las-vegas", 
      "36.092214", "-115.1730278", "3950 Las Vegas Blvd S, Las Vegas, NV 89119", "(702) 632-4555",
      "Lifestyle", "Aquarium"]

    Second = ["Black Mountain Recreation Center",	"12795406", "",	"4b63b174f964a520798c2ae3",
      "http://www.yelp.com/biz/black-mountain-rec-and-aquatic-complex-henderson",
      "36.014432", "-114.975475", "599 Greenway Road, Henderson, NV 89015",
      "(702) 267-4070", "Shopping", "Rec Center"]

    Third = ["Lied Discovery Museum","12795439", "", "4b637769f964a5200d7c2ae3",
      "http://www.yelp.com/biz/lied-discovery-childrens-museum-las-vegas",	"36.179084",	"-115.135869",
      "833 Las Vegas Boulevard North Las Vegas,NV 89101",	"(702) 382-3445",	"Food and Drink", "Museum"]

    Fourth = ["Multi Generational Pool", "12795403", "", "4bbb590d98c7ef3b2e033402",
      "http://www.yelp.com/biz/henderson-multigenerational-center-henderson",	"36.0193767",	"-115.0795269",
      "250 South Green Valley Parkway Henderson, NV 89012",	"(702) 267-5825",	"Business",	"Pool"]

    Fifth = ["Paul Derda Rec Center",	"12792879",	"117068892090229307506", "4bd61e836798ef3bdaa4648d",
      "http://www.yelp.com/biz/paul-derda-recreation-center-broomfield", "39.9348897",	"-105.0362842",
      "13201 Lowell Boulevard, Broomfield, CO 80020",	"+1 303 460 6900", "Lifestyle",	"Rec Center"]

    Locations = {
      '1' => First,
      '2' => Second,
      '3' => Third,
      '4' => Fourth,
    }

    Locations.each_pair do |key, value|
      p key
      location = Location.new(:name => value[0], :WOEID => value[1], :google_maps_cid => value[2], :foursquare_venue_id => value[3],
        :yelp_id => value[4], :latitude => value[5], :longitude => value[6], :full_address => value[7], :phone => value[8],
        :sg_major_category => value[9], :sg_minor_category => value[10])
      if location.save
        p location.inspect
      end

    end
  end

  desc "Populate Divisions"
  task 'divisions' => :environment do
    path = "lib/data/master_ziplatlon.csv"
    csv_table = CSV.table(path, {headers: true, converters: nil, header_converters: :symbol})
    headers = csv_table.headers
    csv_table.each_with_index do|row, index|
      sleep 900 if (index + 1) % 1000 == 0
      row.headers.each{ |cell| row[cell] = row[cell].to_s.strip }
      zip_lat_lng = ZipLatLng.new(:zipcode => row[:zip], :primary_city => row[:primary_city], :state => row[:state],
        :latitude => row[:latitude], :longitude => row[:longitude], :division => row[:division], :ls_division => row[:division])
      if zip_lat_lng.division.blank?
        city_division = CityDivision.where("primary_city like ? AND state like ? ", zip_lat_lng.primary_city, zip_lat_lng.state).first
        if city_division.present?
          zip_lat_lng.division = city_division.division
        else
          request = "https://api.groupon.com/v2/deals.json?postal_code=#{zip_lat_lng.zipcode}&client_id=5efca5ed7ffc721070aab0a9779d579f41bb29df&show=division"
          response = `curl "#{request}"`

          if response && response.length >= 2
            response = JSON.parse(response)
            if response['pagination'].present? && response['pagination']['count'] > 0
              zip_lat_lng.division = response['deals'][0]['division']['id']
              CityDivision.create(:primary_city => zip_lat_lng.primary_city, :state => zip_lat_lng.state, :division => zip_lat_lng.division)
            else
              request = "https://api.groupon.com/v2/deals.json?lat=#{zip_lat_lng.latitude}&lng=#{zip_lat_lng.longitude}&radius=500&client_id=5efca5ed7ffc721070aab0a9779d579f41bb29df&show=division"
              zip_lat_lng.populate_by_lat_lng(request)
            end
            
          else
            request = "https://api.groupon.com/v2/deals.json?lat=#{zip_lat_lng.latitude}&lng=#{zip_lat_lng.longitude}&radius=500&client_id=5efca5ed7ffc721070aab0a9779d579f41bb29df&show=division"
            zip_lat_lng.populate_by_lat_lng(request)
          end
        end
      end

      request = "http://www.livingsocial.com/services/city/v2/cities/nearby/zipcode/#{zip_lat_lng.zipcode}?max=1"
      response = `curl "#{request}"`
      response = JSON.parse(response)
      id = response.class == Array ? (response[0]['id']) : (response['id'])
      zip_lat_lng.ls_division = id
      zip_lat_lng.save
      p "#{zip_lat_lng.primary_city} - #{zip_lat_lng.state} - #{zip_lat_lng.division} - #{zip_lat_lng.ls_division}"
    end
  end

  desc "Populate City Divisions"
  task 'city_division' => :environment do
    path = "lib/data/city_division.csv"
    csv_table = CSV.table(path, {headers: true, converters: nil, header_converters: :symbol})
    headers = csv_table.headers
    csv_table.each do|row|
      row.headers.each{ |cell| row[cell] = row[cell].to_s.strip }
      city_division = CityDivision.new(:primary_city => row[:primary_city], :state => row[:state], :division => row[:division])
      city_division.save
    end
  end

  desc "Populate Goal Advices"
  task 'goal_advice' => :environment do
    path = "lib/data/goal_advice.csv"
    csv_table = CSV.table(path, {headers: true, converters: nil, header_converters: :symbol})
    headers = csv_table.headers
    csv_table.each do|row|
      row.headers.each{ |cell| row[cell] = row[cell].to_s.strip }
      goal_advice = GoalAdvice.new(:goal_type => row[:goal_type].capitalize, :state => row[:state].downcase,
        :expert_advice_description => row[:expert_advice_description], :keywords => row[:keywords],
        :expert_advice_url => row[:expert_advice_url])
      if goal_advice.save
        p "#{goal_advice.keywords} - #{goal_advice.expert_advice_description}"
      end
    end
  end

  desc "Populate Master Keyword table"
  task 'master_keyword' => :environment do

    GoalAdvice.all.each do |goal_advice|
      words = goal_advice.keywords.split(',').map{|word| word.strip}
      words.each do |word|
        master_keyword = MasterKeyword.new(:keyword => word, :category => goal_advice.goal_type,
          :goal_advice_id => goal_advice.id)
        if master_keyword.save
          p "#{master_keyword.keyword} - #{master_keyword.category}"
        end
      end
    end
  end
  
  desc "Living Social category mapping to SnapGadget category ID"
  task 'living_social_mapping' => :environment do
    path = "lib/data/living_social_to_sg.csv"
    csv_table = CSV.table(path, {headers: true, converters: nil, header_converters: :symbol})
    headers = csv_table.headers
    csv_table.each do|row|
      row.headers.each{ |cell| row[cell] = row[cell].to_s.strip }
      ls_external_category = LivingSocialExternalCategory.new(:living_social_category_id => row[:living_social_category_id],
                                                              :snapgadget_category_id => row[:snapgadget_category_id] )
      if ls_external_category.save
        p "#{ls_external_category.living_social_category_id} - #{ls_external_category.snapgadget_category_id}"
      end
    end
    
  end
  
end