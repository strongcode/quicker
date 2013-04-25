module PopulateOffers
  def populate_offers_groupon
    testing = "true"
    if testing != "true"
      division_request = "https://api.groupon.com/v2/divisions.json?client_id=5efca5ed7ffc721070aab0a9779d579f41bb29df&show=id"
      @division_response = `curl "#{division_request}"`
      @division_response = JSON.parse(@division_response)
    else
      @division_response = {"divisions"=>[{"id"=>"denver"}, {"id"=>"las-vegas"}]}
    end

    @division_response['divisions'].each do |division|
      @division_deals_request = "https://api.groupon.com/v2/deals.json?client_id=5efca5ed7ffc721070aab0a9779d579f41bb29df&division_id=#{URI::escape(division['id'])}&show=type,soldQuantityMessage,channels,largeImageUrl,smallImageUrl,mediumImageUrl,status,dealTypes,startAt,dealUrl,title,isSoldOut,tippedAt,AnnouncementTitle,endAt,isTipped,tippedAt,soldQuantity,ShortAnnouncementTitle,merchant,tags,options,division,title,redemptionLocation"
      @division_deals_response = `curl "#{@division_deals_request}"`
      @division_deals_response = JSON.parse(@division_deals_response)

      @division_deals_response['deals'].each do |deal|
        p "Deal is  " + deal['status']
        unless deal['status'].match(/close/i)
          @offer = Offer.find_by_deal_url deal['dealUrl']
          @offer.destroy if @offer.present?
          @offer = Offer.new
          @offer.deal_id = deal['id']
          @offer.deal_end = deal['endAt']
          @offer.deal_start = deal['startAt']
          @offer.deal_source = deal['type']
          @offer.merchant_type = ''
          @offer.deal_header = deal['title']
          @offer.merchant_name = deal['merchant']['name']

          @offer.division_id = division['id']
          @offer.division_lat = deal['division']['lat']
          @offer.division_lng = deal['division']['lng']
          @offer.large_image_url = deal['largeImageUrl']
          @offer.small_image_url = deal['smallImageUrl']
          @offer.status = deal['status']
          @offer.deal_url = deal['dealUrl']
          @offer.deal_tipped = deal['isTipped']
          @offer.deal_tipped_at = deal['tippedAt']
          @offer.redemption_location = deal['redemptionLocation']

          deal['options'].each do |option|
            @offer_option = @offer.offer_options.build
            @offer_option.number_sold = option['soldQuantity']
            @offer_option.value_currency = option['value']['currencyCode']
            @offer_option.value_amount = option['value']['formattedAmount']
            @offer_option.price_currency = option['price']['currencyCode']
            @offer_option.price_amount = option['price']['formattedAmount']
            @offer_option.discount_currency = option['discount']['currencyCode']
            @offer_option.discount_amount = option['discount']['formattedAmount']
            @offer_option.discount_percent = option['discountPercent']
            @offer_option.offer_id = @offer.id
            @offer.update_trend_score
            @offer.save

            option['redemptionLocations'].each do |location|
              @offer_redemption_location = @offer.offer_redemption_locations.build
              @offer_redemption_location.redemption_neighborhood = location['neighborhood']
              @offer_redemption_location.redemption_country = location['country']
              @offer_redemption_location.redemption_street_address1 = location['streetAddress1']
              @offer_redemption_location.redemption_street_address2 = location['streetAddress2']
              @offer_redemption_location.redemption_city = location['city']
              @offer_redemption_location.redemption_state = location['state']
              @offer_redemption_location.redemption_zip_code = location['postalCode']
              @offer_redemption_location.redemption_lat = location['lat']
              @offer_redemption_location.redemption_lng = location['lng']
              @offer_redemption_location.redemption_phone_number = location['phoneNumber']
              @offer_redemption_location.update_woeid
              @offer_redemption_location.offer_option_id =  @offer_option.id
              @offer.save
            end
            @offer.save
          end

          #offer merchant table
          deal['merchant']['ratings'].each do |rating|
            @offer_merchant_rating = @offer.offer_merchant_ratings.build
            @offer_merchant_rating.merchant_rating_site = rating['linkText']
            @offer_merchant_rating.merchant_rating_score = rating['rating']
            @offer_merchant_rating.merchant_rating_reviews = rating['reviewsCount']
            @offer.save
          end

          @tags = ''
          p deal['tags'].length
          if deal['tags'].length == 1
            @tags = "#{deal['tags'][0]['name']}-#{deal['tags'][0]['name']}"
            @offer.category_id = @tags
          else
            deal['tags'].each_with_index do |tag, index|
              break if index > 1
              @tags = @tags + tag['name'] + '-'
            end
            @offer.category_id = @tags[0..@tags.length - 2]
            p @offer.category_id
          end

          @offer.get_snapgadget_category_id_groupon
          @offer.save
        end
      end
    end

  end # End of GROUPON

  # Living Social
  def populate_offers_living_social
    testing = "true"
    if testing != "true"
      division_request = "http://www.livingsocial.com/services/city/v2/cities"
      @division_response = `curl "#{division_request}"`
      @division_response = JSON.parse(@division_response)
    else
      @division_response = {"divisions"=>[{"id"=>"26"}, {"id"=>"864"}]}
    end

    @division_response['divisions'].each do |division|
      @division_deals_request = "http://monocle.livingsocial.com/v2/deals?city=#{URI::escape(division['id'])}&api-key=2574AD58578A419596D95D4D0549A9CF&full=1"
      @division_deals_response = `curl "#{@division_deals_request}"`
      @division_deals_response = JSON.parse(@division_deals_response)

      @division_deals_response['deals'].each do |deal|
        if deal['sold_out'].to_s.match(/false/i)
          @offer = Offer.find_by_deal_url deal['url']
          @offer.destroy if @offer.present?
          @offer = Offer.new
          @offer.deal_id = deal['id']
          @offer.deal_end = deal['offer_ends_at']
          @offer.deal_start = deal['offer_starts_at']
          @offer.deal_source = "livingsocial"
          @offer.merchant_type = ''
          @offer.deal_header = deal['long_title']
          @offer.merchant_name = deal['merchant_name']

          @offer.division_id = division['id']
          @offer.large_image_url = deal['images'][0]['size220']
          @offer.status = "open"
          @offer.deal_url = deal['url']
          @offer.redemption_location = deal['locations'][0].present? ? (deal['locations'][0]['city'] ) : ("Online Deal")

          deal['options'].each do |option|
            @offer_option = @offer.offer_options.build
            
            @offer_option.value_currency = deal['currency_code']
            @offer_option.value_amount = option['original_price']
            @offer_option.price_currency = deal['currency_code']
            @offer_option.price_amount = option['price']

            if option['savings'].blank?
              @offer_option.discount_amount = option['original_price'].to_f - option['price'].to_f
            else
              @offer_option.discount_amount = option['savings'].to_f
            end

            if option['discount'].blank?
              @offer_option.discount_percent = ((100.0 * (@offer_option.value_amount.to_f - @offer_option.price_amount.to_f))/
                                                @offer_option.value_amount.to_f).to_i
            else
              @offer_option.discount_percent = option['discount'].to_i
            end
            
            @offer_option.price_amount = "$" + option['price'].to_s
            @offer_option.discount_amount = "$" + sprintf("%0.02f", @offer_option.discount_amount).to_s
            @offer_option.discount_currency = deal['currency_code']
            @offer_option.offer_id = @offer.id
            @offer.update_trend_score(deal['orders_count'])
            @offer.save
          end
          
          deal['locations'].each do |location|
            @offer_redemption_location = @offer.offer_redemption_locations.build
            @offer_redemption_location.redemption_neighborhood = location['city']
            
            @offer_redemption_location.redemption_street_address1 = location['address1']
            @offer_redemption_location.redemption_street_address2 = location['address2']
            @offer_redemption_location.redemption_city = location['city']
            @offer_redemption_location.redemption_state = location['state']
            
            if Offer::States::List.include?(@offer_redemption_location.redemption_state)
              @offer_redemption_location.redemption_country = deal['county_code']
            else
              @offer_redemption_location.redemption_country = "NONUS"
            end

            @offer_redemption_location.redemption_zip_code = location['postal_code']
            @offer_redemption_location.redemption_lat = location['latlng'][0]
            @offer_redemption_location.redemption_lng = location['latlng'][1]
            @offer_redemption_location.redemption_phone_number = location['phone']
            @offer_redemption_location.update_woeid
            @offer_redemption_location.offer_option_id =  @offer_option.id
            @offer.save
          end
          
          @offer.category_id = deal['categories'][0].to_s + '-' + deal['categories'][1].to_s
          p @offer.category_id
          @offer.get_snapgadget_category_id_living_social
          @offer.save
        end
      end
    end

  end # End of method
  
end